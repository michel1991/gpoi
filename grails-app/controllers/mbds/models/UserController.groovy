package mbds.models



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured

@Transactional(readOnly = true)
class UserController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "POST"]

    def roleService
    def userService
    def userRoleService

    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def userInstanceList = userService.visualisationUtilisateur()
        //println("taille " + userInstanceList.size())

        //respond User.list(params), model:[userInstanceCount: User.count()]
        def int countElement = userService.totalCountUserByProfil()
        respond userInstanceList, model:[userInstanceCount: countElement]
    }

    // C'est pour voir toute les informations concernant la personne on peut rediriger vers modifier ou supprimer
    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def show(User userInstance)
    {
        println("modification reussi show")
        respond userInstance
    }

    @Secured(['ROLE_ADMIN'])
    def create() {
        //redirect action:"index", controller:"user"
        //println("check id user "+ params.id)
        //def value = params.id
        //println("value " + value)
        respond new User(params)
    }


    @Transactional
    @Secured(['ROLE_ADMIN'])
    def save(User userInstance)
    {

        if (userInstance == null) {
            notFound()
            return
        }

        String[] rolesTest = params.role_id
        def listeRoles
        def chaineCoteClientPourIdRole = ""
        if(rolesTest!=null &&  rolesTest.length>0)
        {
            chaineCoteClientPourIdRole = rolesTest.toString().replace("[","").replace("]","")
            listeRoles = roleService.obtenirLaListeDesRole(rolesTest)
        }

        if(userInstance.getPassword()!=params.confirmPassword)
        {
            userInstance.errors.reject('error.motDe.passe', ['password', 'class User'] as Object[], 'Les mots de passe ne correspondent pas')
            userInstance.errors.rejectValue('password', 'error.motDe.passe')
        }

        if (userInstance.hasErrors()) {
            respond userInstance, view:'create', model: [rolesCoches:chaineCoteClientPourIdRole]
            return
        }
        //redirect(action: "create", controller: "user")
        //redirect action:"index", controller:"user"
        //userInstance.save flush:true

        //redirect(uri: "user/create")
        if(listeRoles.size()>0)
        {
            userService.ajouterUtilisateur(userInstance, listeRoles)
            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), userInstance.id])
                    flash.successSave = "ok"
                    redirect action: "create", controller: "user"
                }
                '*' { respond userInstance, [status: CREATED] }
            }
        }else{
            flash.successSave = "ko"
            redirect action: "create", controller: "user"
        }

    }

    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def edit(User userInstance) {
        if (userInstance == null) {
            notFound()
            return
        }


        def chaineRoleAffecte = roleService.listeRoleUtilisateurChainePourModifier(userInstance)
        respond userInstance, model:[rolesCoches:chaineRoleAffecte]
    }

    @Transactional
    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def update(User userInstance) {
        if (userInstance == null) {
            notFound()
            return
        }

        String[] rolesTest = params.role_id
        def listeRolesInsert
        def chaineCoteClientPourIdRole = ""
        if(rolesTest!=null &&  rolesTest.length>0)
        {
            chaineCoteClientPourIdRole = rolesTest.toString().replace("[","").replace("]","")
            listeRolesInsert = roleService.obtenirLaListeDesRole(rolesTest)
        }

        if(userInstance.getPassword()!=params.confirmPassword)
        {
            userInstance.errors.reject('error.motDe.passe', ['password', 'class User'] as Object[], 'Les mots de passe ne correspondent pas')
            userInstance.errors.rejectValue('password', 'error.motDe.passe')
        }

        if (userInstance.hasErrors()) {
            respond userInstance.errors, view:'edit', model: [rolesCoches:chaineCoteClientPourIdRole]
            return
        }

        User userManager = null
        //userInstance.save flush:true
        if(listeRolesInsert.size()>0)
        {
            userManager = userService.miseAjourUtilisateur(userInstance, listeRolesInsert)
            flash.infoOperation = "ok"
        }else{
            flash.infoOperation = "ko"
        }

        flash.natureInfo ="update"
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'User.label', default: 'User'), userInstance.id])
                redirect action: "index", controller: "user"
            }
            '*'{ respond userInstance, [status: OK] }
        }
    }

    @Transactional
    @Secured(['ROLE_ADMIN'])
    def delete(User userInstance) {

        if (userInstance == null) {
            notFound()
            return
        }

        //println("entrer " + userInstance.getId())
        //userInstance.delete flush:true
        //userService.suppressionUtilisateur(userInstance)

        def String groupeToRemove = params.valueToRemove
        User userManager = userService.getUtilisateurToDelete(groupeToRemove)
        if(userManager!=null)
        {
            userService.suppressionUtilisateur(userManager)
            flash.infoOperation = "ok"
        }else{
            flash.infoOperation = "ko"
        }
        flash.natureInfo ="delete"


        redirect action:"index", controller: "user"

    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

}
