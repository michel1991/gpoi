import mbds.models.User
import mbds.models.Illustration
import mbds.models.Poi

import mbds.models.Role
import mbds.models.UserRole
import mbds.models.Groupe
import groovy.json.JsonBuilder
class BootStrap {

    def grailsApplication
    def  roleService
    def userService

    def init = { servletContext ->
        def adminRole = roleService.createRoleApplication(new Role('ROLE_ADMIN'))
        def userRole = roleService.createRoleApplication(new Role('ROLE_USER'))
        def moderateur = roleService.createRoleApplication(new Role('ROLE_MODERATOR'))


        //UTILISATEUR
        def user1 = new User("michel", "michel")
        user1.setTel("0612588458")
        user1.setEmailUser("michel1@yahoo.fr")
        user1.setConfirmPassword("michel")
        List<Role> listeRoleUser1 = new ArrayList<>()
        listeRoleUser1.add(adminRole)

        def user2 = new User('mimi', 'mimi')
        user2.setTel("0612588457")
        user2.setEmailUser("mimi@yahoo.fr")
        user2.setConfirmPassword("mimi")
        List<Role> listeRoleUser2 = new ArrayList<>()
        listeRoleUser2.add(moderateur)

        def user3 = new User('clea', 'michel')
        user3.setTel("0612588454")
        user3.setEmailUser("clea@yahoo.fr")
        user3.setConfirmPassword("michel")
        List<Role> listeRoleUser3 = new ArrayList<>()
        listeRoleUser3.add(userRole)

        //GROUPE IMAGE
        def greenTeamImage = new Illustration(nom:"green_team.jpg")
        def greenTeam=new Groupe(nom:"Endroits à visiter")
        List<Poi> listePoiGreenTeam = new ArrayList<>()

        //POI FIRST GROUPE
        listePoiGreenTeam.add(new Poi(nom: "Hospital Saint Roch", adresse:"258 Rue de l'hotel des postes 06300 Nice", latitude: new Double(43.702922), longitude:new Double(7.274967)))
        listePoiGreenTeam.add(new Poi(nom: "Titoeuf pizza", adresse: "14 Rue Pastorelli 14 Rue Pastorelli", latitude: new Double(43.702115), longitude:new Double(7.273316)))
        listePoiGreenTeam.add(new Poi(nom: "Eden Bar", adresse:  "34 Rue Tonduti de l'Escarène 06000 Nice", latitude:  new Double(43.702050), longitude:  new Double(7.273147)))
        listePoiGreenTeam.add(new Poi(nom: "SCP ASSUS", adresse:  "36 Rue Tonduti de l'Escarène 06000 Nice", latitude:  new Double(43.702078), longitude:  new Double(7.272963)))
        listePoiGreenTeam.add(new Poi(nom:  "Le Narval", adresse:  "14 Rue Pastorelli 06000 Nice", latitude:  new Double(43.702159), longitude:  new Double(7.273262)))
        user1 = userService.ajouterUtilisateurComplex(user1, listeRoleUser1,listePoiGreenTeam, greenTeam, greenTeamImage)

        def sparkNangaImageImage = new Illustration(nom: "lieuxCultes.jpg")
        def sparkNangaTeam = new Groupe(nom:"Lieux Cultes")
        List<Poi> listePoisparkNangaTeam = new ArrayList<>()

        listePoisparkNangaTeam.add(new Poi(nom: "Maido", adresse: "29 Rue Tonduti de l'Escarène 06300 Nice", latitude: new Double(43.701986), longitude: new Double(7.272619)))
        listePoisparkNangaTeam.add(new Poi(nom: "Kililie's Resto-Brunch", adresse: "20 Rue Delille 06300 Nice", latitude: new Double(43.702176), longitude: new Double(7.274727)))
        listePoisparkNangaTeam.add(new Poi(nom: "Galerie Scholtès", adresse: "18 Rue Pastorelli 06000 Nice", latitude: new Double(43.701668), longitude: new Double(7.273038)))
        listePoisparkNangaTeam.add(new Poi(nom: "E-Evolution", adresse: "4 Rue de l'Hôtel des Postes 06000 Nice", latitude: new Double(43.701586), longitude: new Double(7.274652)))
        listePoisparkNangaTeam.add(new Poi(nom: "DDFIP", adresse: "15 bis Rue Delille, 06000 Nice", latitude: new Double(43.701773), longitude:  new Double(7.275355)))
        listePoisparkNangaTeam.add(new Poi(nom: "DDFIP1", adresse: "15 bis Rue Delille, 06000 Nice", latitude: new Double(43.701773), longitude:  new Double(7.275355)))
        userService.ajouterUtilisateurComplex(user1, new ArrayList<Role>(), listePoisparkNangaTeam, sparkNangaTeam, sparkNangaImageImage)

        def lastImage = new Illustration(nom: "decouverte.jpg")
        def lastTeam = new Groupe(nom:"Une découverte")
        List<Poi> listePoislastTeam = new ArrayList<>()

        listePoislastTeam.add(new Poi(nom: "Boulangerie Patisserie Carabacel", adresse: "9 Rue Pastorelli 06000 Nice", latitude: new Double(43.702194), longitude:new Double(7.273619)))
        listePoislastTeam.add(new Poi(nom:"Saydawi", adresse:"7 Rue Pastorelli 06300 nice", latitude:new Double(43.702293), longitude:new Double(7.273667)))
        listePoislastTeam.add(new Poi(nom:"Bejuy Alain Charles", adresse:"7 Rue Pastorelli 06300 nice",  latitude:new Double(43.702274), longitude:new Double(7.273748)))
        listePoislastTeam.add(new Poi(nom:"Lounge Air", adresse:"11 Rue Pastorelli 06300 nice",  latitude:new Double(43.702106), longitude:new Double(7.273561)))
        listePoislastTeam.add(new Poi(nom: "Fox in a Box Nice", adresse: "29 Rue Delille, 06000 Nice", longitude:new Double(43.702345), latitude:new Double(7.273480)))
        user2 = userService.ajouterUtilisateurComplex(user2, listeRoleUser2, listePoislastTeam, lastTeam, lastImage)

        userService.ajouterUtilisateur(user3, listeRoleUser3)
    }
    def destroy = {
    }
}
