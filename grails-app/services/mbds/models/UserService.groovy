package mbds.models

import grails.transaction.Transactional

@Transactional
class UserService {

    def roleService
    def springSecurityService


    def ajouterUtilisateur(User user, ArrayList<Role> listesRoles) {

        user = user.save(failOnError: true, flush: true)
        listesRoles.each { role ->
            UserRole.create(user, role, true)
        }
        return user
    }


    def List<User> visualisationUtilisateur()
    {
        User user = springSecurityService.getCurrentUser()
        String plusGrandRoleUtilisateur = roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        Role role = Role.findByAuthority(plusGrandRoleUtilisateur)
        List<User> listeUtilisateurDisponible = new ArrayList<>()
        if(role!=null)
        {
            switch (role.getAuthority())
            {
                case "ROLE_ADMIN":
                    listeUtilisateurDisponible = User.listOrderByUsername(order: "asc")
                    listeUtilisateurDisponible.remove(user)
                    break
                case "ROLE_MODERATOR":
                    List<UserRole> listUserRole = UserRole.findAllWhere(role:Role.findByAuthority("ROLE_USER"))
                    if(listUserRole!=null)
                    {
                        listUserRole.each {roleUser->
                            listeUtilisateurDisponible.add(roleUser.getUser())
                        }
                    }
                    break

                case "ROLE_USER":
                    listeUtilisateurDisponible.add(user)
                    break
            }
        }
        return listeUtilisateurDisponible

    }

    def User miseAjourUtilisateur(User userInstance, listeRolesInsert)
    {
        User userInstanceM = userInstance.merge()
        UserRole.removeAll(userInstanceM, true)
        for(Role roleInsert : listeRolesInsert)
        {
            UserRole.create(userInstanceM, roleInsert, true)
        }
        return userInstanceM
    }

    def void suppressionUtilisateur(User userInstance)
    {
        User userInstanceM = userInstance.merge()
        UserRole.removeAll(userInstanceM, true)
        userInstanceM.delete(flush: true)
    }

    /**
     *
     * @param userToRemove
     * @return
     */
    def User getUtilisateurToDelete(def String userToRemove) {
        User userManager =null
        if (userToRemove != null && userToRemove.length()) {
            try {
                Long idUser = Long.parseLong(userToRemove)
                userManager= User.findById(idUser)


            } catch (Exception ex) {
                userManager=null
            }
        }
        return  userManager
    }

    def User ajouterUtilisateurComplex(User user, ArrayList<Role> listesRoles, List<Poi> listPois, Groupe groupe, Illustration image)
    {
        if(User.findById(user.getId())==null)
        {
            user= ajouterUtilisateur(user, listesRoles)
        }else{
            user = user.merge()
        }
        image = image.save(failOnError: true, flush: true)
        groupe.setUser(user)
        groupe.setImage(image)
        for(Poi poi : listPois)
        {
            poi.setUser(user)
            groupe.addToPois(poi)
        }
        groupe.save(failOnError: true, flush: true)

        return user
    }

    def int totalCountUserByProfil()
    {
        User userCurrent = springSecurityService.getCurrentUser()
        String roleName = roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        def int countElement = 0;
        switch(roleName)
        {
            case "ROLE_ADMIN":
                countElement = User.list().size()
                if(countElement>0)
                    countElement = countElement-1

                break
            case "ROLE_MODERATOR":
                Role role = Role.findByAuthority("ROLE_USER")
                countElement = UserRole.executeQuery("SELECT  usr FROM  UserRole usr JOIN  usr.role WHERE usr.role=?", [role]).size()
                //countElement= User.findAll("from User, User where p.user=? order by p.nom",[userCurrent]).size()
                break

            case "ROLE_USER":
                countElement = 1
                break
        }
        return countElement
    }

}
