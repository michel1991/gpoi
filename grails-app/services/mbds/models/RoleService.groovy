package mbds.models

import grails.transaction.Transactional
//import grails.plugin.springsecurity.SpringSecurityService

@Transactional
class RoleService {

    def springSecurityService

    /**
     * Renvoi la liste des roles selon le profil de l'utilisateur qui se connecte(utilisateur actuellement connecté) si administrateur tous les roles
     * Si Modeerateur role utilisateur uniquement utile pour la création d'un nouveau utilisateur
     * @return
     */
    def ArrayList<Role> listeRoleAccessibleUtilisateur()
    {
        def user = springSecurityService.getCurrentUser()
         List<Role> listeRoles = new ArrayList<Role>()
        if(user!=null)
        {
            def adminstrateurRole = Role.findByAuthority("ROLE_ADMIN")
            def moderateurRole = Role.findByAuthority("ROLE_MODERATOR")

            def listSetRoles = user.getAuthorities()
            if(listSetRoles!=null && listSetRoles.size()>0)
            {
                if(adminstrateurRole!=null && listSetRoles.contains(adminstrateurRole))
                {
                    listeRoles= Role.findAll()
                }else //if(moderateurRole!=null && listSetRoles.contains(moderateurRole))
                {
                    //listeRoles = Role.findByAuthority("ROLE_USER")
                    listSetRoles.each { role ->
                        listeRoles.add(role)
                    }

                }
            }
        }
        return listeRoles
    }

    /**
     * Renvoi la liste des roles de l'utilisateur fonction d'un tableau des identifiants roles en chaine
     * @param listeDesIdDesRole
     * @return
     */
    def ArrayList<Role> obtenirLaListeDesRole(String[] listeDesIdDesRole)
    {
        List<Role> listeRoles = new ArrayList<Role>()

        if(listeDesIdDesRole.length>0)
        {
            listeDesIdDesRole.each {roleIdChaine ->
                listeRoles.add(Role.findById(Long.parseLong(roleIdChaine)))
            }
        }
        return listeRoles
    }
    /**
     * Retourne le plus grand role de l'utilisateur connecté parmi sa liste de role
     * @return
     */
    def String rechercheDeLaPlusGrandeAuthorityUtilisateur()
    {
        def rolesUtilisateur = listeRoleAccessibleUtilisateur()
        def adminstrateurRole = Role.findByAuthority("ROLE_ADMIN")
        def moderateurRole = Role.findByAuthority("ROLE_MODERATOR")

        def nomRole =""
        if(adminstrateurRole!=null && rolesUtilisateur.contains(adminstrateurRole))
        {
            nomRole ="ROLE_ADMIN"
        }else if(moderateurRole!=null && rolesUtilisateur.contains(moderateurRole))
        {
            nomRole ="ROLE_MODERATOR"
        }else{
            nomRole ="ROLE_USER"
        }
        return nomRole
    }

    /**
     * Renvoi une chaine formatée de la liste des role dont dispose l'utilisateur exemple 1,2,3
     * @param listeRolesUserToUpdate
     * @return
     */
    def String formatageRoleUtilisateurAModifierSousFormeDeChaineAvecVirgule(ArrayList<Role> listeRolesUserToUpdate)
    {
        String chaineRole=""
        for (int i =0; i<listeRolesUserToUpdate.size(); i++)
        {

            //chaineRole+=(i+1)>=listeRolesUserToUpdate.size()?String.valueOf(listeRolesUserToUpdate.get(i).id):String.valueOf(listeRolesUserToUpdate.get(i).id)+","
            chaineRole+=String.valueOf(listeRolesUserToUpdate.get(i).id)+","
        }
        return chaineRole
    }

    /**
     * Renvoi la liste des role d'un utilisateur specifique
     * @param userInstance
     * @return
     */
    def List<Role> obtenirLaListeDesRoleUtilisateurSpecifique(User userInstance)
    {
        List<Role> listeRoles = new ArrayList<Role>()
        List<UserRole> userRoleList = UserRole.findAllWhere(user: userInstance)
        userRoleList.each {
            userRole-> listeRoles.add(userRole.getRole())
        }
        return listeRoles
    }

    def String listeRoleUtilisateurChainePourModifier(User userInstance)
    {
        List<Role> listeRoles = obtenirLaListeDesRoleUtilisateurSpecifique(userInstance)
        return formatageRoleUtilisateurAModifierSousFormeDeChaineAvecVirgule(listeRoles)
    }

    def Role createRoleApplication(Role role)
    {
      return  role.save(failOnError: true, flush: true)
    }
}
