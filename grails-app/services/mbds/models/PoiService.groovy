package mbds.models

import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonBuilder
import org.codehaus.groovy.grails.web.json.JSONArray

@Transactional
class PoiService {
    def springSecurityService

    def groupeService
    def roleService

    /**
     * Recuperation de la liste des groupes
     * @param listeDesIdDesGroupes
     * @return
     */
    def ArrayList<Groupe> obtenirLaListeDesGroupes(String[] listeDesIdDesGroupes)
    {
        List<Groupe> listeGroupes = new ArrayList<Groupe>()

        if(listeDesIdDesGroupes.length>0)
        {
            listeDesIdDesGroupes.each {groupeIdChaine ->
                listeGroupes.add(Groupe.findById(Long.parseLong(groupeIdChaine)))
            }
        }
        return listeGroupes
    }

    /**
     * Enregistrement du poi
     * @param image
     * @param poiInstance
     * @param listeGroupes
     */
    def void enregisterPoi(Illustration image, Poi poiInstance, ArrayList<Groupe> listeGroupes)
    {
        if(image!=null)
        {
            image.save(failOnError: true, flush: true)
            poiInstance.setImage(image)
        }

        poiInstance.save(failOnError: true, flush: true)

        if(listeGroupes!=null && listeGroupes.size()>0)
        {
            listeGroupes.each {
                groupePoiInstance->
                    Groupe managerGroupe = groupePoiInstance.merge()
                    managerGroupe.addToPois(poiInstance)
                    managerGroupe.merge()
            }
        }

    }

    /**
     * update renvoi de la liste des groupes
     * @param poiInstance
     * @return
     */
    def String updateListeGroupePoi(Poi poiInstance)
    {
        def String[] tabGroupe = new String[poiInstance.getGroupes().size()]
         def int compteur = 0
        poiInstance.getGroupes().each {
            groupe ->
                tabGroupe[compteur] = groupe.getId()
                compteur++
        }

        return tabGroupe.toString().replace("[","").replace("]","")
    }

    def String updatePoi(def f, def Poi poiInstance,  def String oldNameString, ArrayList<Groupe> listeGroupes)
    {
        def boolean result = false
        Poi poiInstanceManager = null
        def userCurrent = springSecurityService.getCurrentUser()
        def String resultOperation ="ko"

        if(f.getOriginalFilename().length()==0) // la même photo est renvoyée
        {
            poiInstanceManager = poiInstance.merge()
            deleteAllGroupePoiInstanceManager(poiInstanceManager)
            addAllGroupePoiInstanceManager(poiInstanceManager, listeGroupes)

            def String rmiGet = groupeService.informationSuppressionImage(oldNameString)
            if(rmiGet.equals("rmi"))
            {
                oldNameString = groupeService.getNomImageCorrcete(oldNameString)
                result  = groupeService.deleteFileIntoFolder(oldNameString)

                Illustration image = Illustration.findById(poiInstanceManager.getImage().getId())
                poiInstanceManager.setImage(null)
                image.delete(flush: true)

            }

            resultOperation="ok"
        }else if(f.getOriginalFilename().length()>0)
        {
            oldNameString = groupeService.getNomImageCorrcete(oldNameString)
            result  = groupeService.deleteFileIntoFolder(oldNameString)
            def String nomNouvelleImage =  groupeService.writeFileIntoDisk(f)

            if(nomNouvelleImage!=null && nomNouvelleImage.length()>0)
            {
                poiInstanceManager = poiInstance.merge()
                deleteAllGroupePoiInstanceManager(poiInstanceManager)
                addAllGroupePoiInstanceManager(poiInstanceManager, listeGroupes)

                if(poiInstanceManager.getImage()==null)
                {
                    Illustration imageIllustration = new Illustration(nom:nomNouvelleImage, user:userCurrent)
                    imageIllustration.save(failOnError: true, flush: true)
                    poiInstanceManager.setImage(imageIllustration)
                }else{
                    poiInstanceManager.getImage().setNom(nomNouvelleImage)
                }
                resultOperation="ok"
            }
        }
        return resultOperation
    }

    /**
     *
     * @param poiInstance
     */
    def void deleteAllGroupePoiInstanceManager(Poi poiInstance)
    {
        def HashSet<Groupe> listeGroupe = poiInstance.getGroupes()

        for (Iterator<Groupe> iterator = listeGroupe.iterator(); iterator.hasNext(); ) {
            Groupe groupe = iterator.next();
            iterator.remove();
            groupe.removeFromPois(poiInstance)
        }

        /*poiInstance.getGroupes().each {
            groupe ->
                groupe.removeFromPois(poiInstance)
                groupe.merge()
        }*/
    }

    /**
     *
     * @param poiInstance
     * @param listeGroupes
     */
    def void addAllGroupePoiInstanceManager(Poi poiInstance, def ArrayList<Groupe> listeGroupes)
    {
        listeGroupes.each {
            groupe ->
                Groupe groupeManager = groupe.merge()
                groupeManager.addToPois(poiInstance)
        }
    }

    def String supprimerPoi(def String poiToRemove)
    {
        def String result = "ko"
        if(poiToRemove!=null && poiToRemove.length())
        {
            try{
                Long idPoi = Long.parseLong(poiToRemove)
                Poi poiManager = Poi.findById(idPoi)

                if(poiManager!=null)
                {
                    if(poiManager.getImage()!=null)
                    {
                        String name = poiManager.getImage().getNom()
                        String locationPhysique = grailsApplication.config.grails.projet.gpoi.server.folder.image
                        String name2 = locationPhysique+"$name"
                        boolean resultSupprime  = groupeService.deleteFileIntoFolder(name2)

                        println("boolean supprime POI" + resultSupprime)
                        if(resultSupprime)
                        {
                            deleteAllGroupePoiInstanceManager(poiManager)
                            poiManager.delete flush:true
                            result="ok"
                        }else{
                            result="ko"
                        }
                    }else{
                        deleteAllGroupePoiInstanceManager(poiManager)
                        poiManager.delete flush:true
                        result="ok"
                    }
                }

            }catch(Exception exception)
            {
                result="ko"
            }
        }

        return result
    }

     /**
     * LISTE POI PAR PROFIL
     */
    def List<Poi> getLisPoiParProfil(def params)
    {
        List<Poi> listesPois = new ArrayList<>()
        User userCurrent = springSecurityService.getCurrentUser()
        String roleName = roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        switch(roleName)
        {
            case "ROLE_ADMIN":
                params.order="asc"
                params.sort="nom"
                listesPois = Poi.list(params)
                //println("role " + roleName + " name " + params.name)
                break
            case "ROLE_MODERATOR":
                def startIndex = params.offset?:0
                def  limit = params.max
                listesPois = Poi.findAll("from Poi as p where p.user=? order by p.nom",
                        [userCurrent], [max:limit, offset:startIndex])
                /*listPois =Poi.findAll([max:limit, offset:startIndex]){
                    user==userCurrent
                }.sort ({name:'asc'})*/
                break

            case "ROLE_USER":
                params.order="asc"
                params.sort="nom"
                listesPois = Poi.list(params)
                break
        }
        return listesPois
    }

    def int totalCountPoiByProfil()
    {
        User userCurrent = springSecurityService.getCurrentUser()
        String roleName = roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        def int countElement = 0;
        switch(roleName)
        {
            case "ROLE_ADMIN":
                countElement = Poi.list().size()
                break
            case "ROLE_MODERATOR":
                countElement= Poi.findAll("from Poi as p where p.user=? order by p.nom",[userCurrent]).size()
                break

            case "ROLE_USER":
                countElement = Poi.list().size()
                break
        }
        return countElement
    }

    /**
     * CONSTRUIT UN OBJET POI JSON
     * @param poiInstance
     * @return
     */
    def builJsonPoiLocalisation(Poi poiInstance)
    {
        JsonBuilder json = new JsonBuilder ()
        def String imagePoi = poiInstance.getImage()==null?"":poiInstance.getImage().getNom()
        //println("image " + imagePoi)
        def map = json{
            nom  poiInstance.getNom()
            id  poiInstance.getId()
            image  imagePoi
            latitude  poiInstance.getLatitude()
            longitude  poiInstance.getLongitude()
            description  poiInstance.getDescription()
            addresse  poiInstance.getAdresse()
            tel poiInstance.getTel()
            groupe poiInstance.getGroupes().collect {
                groupeInstance->
                    def imageGroupe = groupeInstance.getImage()==null?"":groupeInstance.getImage().getNom()
                    [
                            nomG :groupeInstance.getNom(),
                            imageGroupe : imageGroupe
                    ]
            }
        }


        //println("resultat "+json.toPrettyString())
        return json.toPrettyString()
    }

    /**
     * CONSTRUIT UNE LISTE OBJET POI JSON
     * @param groupe
     * @return
     */
    def builJsonsPoiGroupeLocalisation(Groupe groupe)
    {
        //JSONArray arrayJ = new JSONArray()
        String[] arrayJ = new String[groupe.getPois().size()]
        int count = 0
        groupe.getPois().collect {
            poiInstance ->
                def json =  builJsonPoiLocalisation(poiInstance)
                /*arrayJ.add(json)*/
                arrayJ[count] = json
                count++
        }
        return arrayJ
    }
}
