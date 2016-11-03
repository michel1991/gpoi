package mbds.models

import grails.transaction.Transactional

@Transactional
class UserRoleService {

    def roleService

    /**
     * Supprimer les anciens role de l'utilisateur
     * @param userInstance
     * @return
     */
    def supprimerTousLesRoleDeAncienUtilisateur(User userInstance)
    {
        List<Role> listRoles = roleService.obtenirLaListeDesRoleUtilisateurSpecifique(userInstance);
        listRoles.each {
            role->
                UserRole.remove(userInstance,  role, true)
                //userRole.delete(flush:  true)
                //println("supprimer")
        }
    }

    def ajouterUserRole(User user, ArrayList<Role> listesRoles){

        listesRoles.each {role->
            UserRole.create(user, role, true)
        }
    }
}
