package mbds.models

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class RoleController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def roleService

    @Secured(["hasRole('ROLE_ADMIN')", "hasRole('ROLE_USER')", "hasRole('ROLE_MODERATOR')"])
    def index(Integer max) {

        println("max " + max)
        max = max ?: 10
        params.max = Math.min(max, 100)
        println("max " + params.max)
        respond Role.list(params), model:[roleInstanceCount: 40]  //Role.count()
    }

    @Secured(["hasRole('ROLE_ADMIN')", "hasRole('ROLE_USER')", "hasRole('ROLE_MODERATOR')"])
    def show(Role roleInstance) {
        respond roleInstance
    }

    def create() {
        respond new Role(params)
    }

    @Transactional
    def save(Role roleInstance) {
        if (roleInstance == null) {
            notFound()
            return
        }

        if (roleInstance.hasErrors()) {
            respond roleInstance.errors, view:'create'
            return
        }

        roleInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'role.label', default: 'Role'), roleInstance.id])
                redirect roleInstance
            }
            '*' { respond roleInstance, [status: CREATED] }
        }
    }

    def edit(Role roleInstance) {
        respond roleInstance
    }

    @Transactional
    def update(Role roleInstance) {
        if (roleInstance == null) {
            notFound()
            return
        }

        if (roleInstance.hasErrors()) {
            respond roleInstance.errors, view:'edit'
            return
        }

        roleInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Role.label', default: 'Role'), roleInstance.id])
                redirect roleInstance
            }
            '*'{ respond roleInstance, [status: OK] }
        }
    }


    @Transactional
    def delete(Role roleInstance) {

        if (roleInstance == null) {
            notFound()
            return
        }

        roleInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Role.label', default: 'Role'), roleInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def listeAuthoritiesUtilisateur() // liste des role disponible appel exclusif au ayant droit
    {
        render(template: "selectHtmlRoles", model:[roles:roleService.listeRoleAccessibleUtilisateur()])
    }

    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR', 'ROLE_USER'])
    def plusGrandRoleUtilisateur()
    {
        def nomRole =roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        render(template: "sideBar", model:[plusGrand:nomRole])
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'role.label', default: 'Role'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
