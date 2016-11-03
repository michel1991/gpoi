package central
import grails.plugin.springsecurity.annotation.Secured
import mbds.models.User

class BienvenueController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def springSecurityService

    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def index()
    {
        User user = springSecurityService.getCurrentUser()
        session["idUser"] = user.getId()
        render(view: "/index")
    }
}
