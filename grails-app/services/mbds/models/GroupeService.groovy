package mbds.models

import grails.transaction.Transactional
import groovy.json.JsonBuilder

import java.text.SimpleDateFormat
import groovy.sql.Sql

@Transactional
class GroupeService {

    def grailsApplication

    def springSecurityService
    def roleService
    def sessionFactory

    def Groupe creerGroupeAndImage(def f, String nomGroupe)
    {
        def userCurrent = springSecurityService.getCurrentUser()
        Date now = new Date()
        SimpleDateFormat timestamp = new SimpleDateFormat("yyyyMMddHHmmss")
        def nameHashFile = timestamp.format(now)
        def fos= null
        Groupe groupeManager = null
        boolean verifOperation = true
        Groupe groupe = null

        if(f!=null)
        {
            final String name =nameHashFile+""+f.getOriginalFilename()
            String locationPhysique = grailsApplication.config.grails.projet.gpoi.server.folder.image
            String name2 = locationPhysique+"$name"

            try{
                fos= new FileOutputStream(new File(name2))
                f.getBytes().each {
                    fos.write(it)
                }
                fos.flush()
                fos.close()
            }catch(Exception exception)
            {
                verifOperation = false;
            }

            if(verifOperation)
            {

                Illustration imageIllustration = new Illustration(nom:name, user:userCurrent)
                imageIllustration.save(failOnError: true, flush: true)
                groupe = new Groupe(nom:nomGroupe, image:imageIllustration, user:userCurrent)
                groupeManager = groupe.save(failOnError: true, flush: true)
            }
        }else{
            groupe = new Groupe(nom:nomGroupe, image:imageIllustration, user:userCurrent)
            groupeManager = groupe.save(failOnError: true, flush: true)
        }
        return groupeManager
       // println(name)
    }

    /**
     * Mise à jour du groupe
     * @param f
     * @param groupeInstance
     * @param oldNameString
     * @return
     */
    def String updateGroupe(def f, def Groupe groupeInstance,  def String oldNameString)
    {
        def boolean result = false
        Groupe groupeInstanceManager = null
        def userCurrent = springSecurityService.getCurrentUser()
        def String resultOperation ="ko"
        if(f.getOriginalFilename().length()==0) // la même photo est renvoyée
        {
            groupeInstanceManager = groupeInstance.merge()
            def String rmiGet = informationSuppressionImage(oldNameString)
            if(rmiGet.equals("rmi"))
            {
                oldNameString = getNomImageCorrcete(oldNameString)
                result  = deleteFileIntoFolder(oldNameString)
                //println("id " +  groupeInstanceManager.getImage().getId())

                Illustration image = Illustration.findById(groupeInstanceManager.getImage().getId())
                groupeInstanceManager.setImage(null)
                image.delete(flush: true)

                //groupeInstance.getImage().delete()
                //groupeInstance.merge()
            }
            resultOperation="ok"
        }else if(f.getOriginalFilename().length()>0)
        {
            oldNameString = getNomImageCorrcete(oldNameString)
            //println("def > " + oldNameString)
            result  = deleteFileIntoFolder(oldNameString)
            def String nomNouvelleImage =  writeFileIntoDisk(f)
            if(nomNouvelleImage!=null && nomNouvelleImage.length()>0)
            {
                groupeInstanceManager = groupeInstance.merge()

                if(groupeInstanceManager.getImage()==null)
                {
                    Illustration imageIllustration = new Illustration(nom:nomNouvelleImage, user:userCurrent)
                    imageIllustration.save(failOnError: true, flush: true)
                    groupeInstanceManager.setImage(imageIllustration)
                }else{
                    groupeInstanceManager.getImage().setNom(nomNouvelleImage)
                }
                //groupeInstanceManager.getImage().delete()
                //Illustration imageIllustration = new Illustration(nom:nomNouvelleImage, user:userCurrent)
                //imageIllustration.save(failOnError: true, flush: true)
                //groupeInstanceManager.setImage(imageIllustration)
                resultOperation="ok"
            }
            /*if(result) // si la suppression s'est bien deroulée
            {

            }*/
        }

        return resultOperation
    }

    /**
     * Recherche si on doit supprimer l'image rmi
     * @param oldNameString
     * @return
     */
    def String informationSuppressionImage(oldNameString)
    {
        def int indexString =oldNameString.lastIndexOf(".")
        String resultatRmi =""
        if(indexString!=-1)
        {
            resultatRmi = oldNameString.substring(indexString+4)
            //println("resultat " + resultat + " resultat 2 " + oldNameString.substring(0, indexString+4))
        }else{
            resultatRmi = oldNameString
        }
        return resultatRmi
    }

    def String getNomImageCorrcete(oldNameString)
    {
        def int indexString =oldNameString.lastIndexOf(".")
        String resultatRmi =""
        if(indexString!=-1)
        {
            resultatRmi = oldNameString.substring(0, indexString+4)
        }
        return resultatRmi
    }


    /**
     * Ecrire l'image sur le disque et renvoi le nom du fichier qui sera utilisé dans la table image
     * @param f
     * @return
     */
    def String writeFileIntoDisk(def f)
    {
        Date now = new Date()
        SimpleDateFormat timestamp = new SimpleDateFormat("yyyyMMddHHmmss")
        def nameHashFile = timestamp.format(now)

        final String name =nameHashFile+""+f.getOriginalFilename()
        String locationPhysique = grailsApplication.config.grails.projet.gpoi.server.folder.image
        String name2 = locationPhysique+"$name"
        def fos= null

        try{
            fos= new FileOutputStream(new File(name2))
            f.getBytes().each {
                fos.write(it)
            }
            fos.flush()
            fos.close()
        }catch(Exception exception)
        {
           name =""
        }
        return name
    }

    def boolean deleteFileIntoFolder(def String fileLocalisation)
    {
            boolean flatResult = false
        if(fileLocalisation!=null && fileLocalisation.length()>0)
        {
            try{
                File file = new File(fileLocalisation)
                if(file.exists()) {
                    flatResult = file.delete()
                }
            }catch(Exception excemption)
            {
                flatResult = false
            }
        }

        return flatResult
    }

    /**
     *
     * @param groupeInstance
     * @return
     */
    def String listePoisGroupeJson(Groupe groupeInstance)
    {
        def listePoisGroupe = groupeInstance.getPois()
        def String chaineObject = ""
        def String[] tableauObjet = null
        if(listePoisGroupe!=null && listePoisGroupe.size()>0)
        {
            tableauObjet = new String[listePoisGroupe.size()]
            def int compteur = 0
            for (Poi poi : listePoisGroupe)
            {
                def jsonBuilder = new JsonBuilder()
                jsonBuilder(
                        latitude : poi.getLatitude(),
                        longitude : poi.getLongitude(),
                        image:poi.getImage()!=null?poi.getImage().getNom():""
                )
                //chaineObject+=poi.getLatitude()+":"+poi.getLongitude()+";"
                tableauObjet[compteur] = jsonBuilder.toPrettyString()
                compteur++
            }

        }

        if(tableauObjet!=null)
        {
            //println("tableau " + tableauObjet.toString())
            //return tableauObjet.toString().replace("[","").replace("]","").replace(" ","")
            return tableauObjet.toString().replace(" ","")
        }else{
           return ""
        }
    }

    /**
     * Obtenir la liste des pois du groupes pas de doublon
     * @param groupeInstance
     * @return
     */
    def HashSet<Poi> obtenirPoisGroupe(Groupe groupeInstance)
    {
        return groupeInstance.getPois()
    }

    def List<Poi> obtenirPoisNotInGroup(Groupe groupeInstance)
    {
        def sql = new Sql(sessionFactory.currentSession.connection())
        def idGroupe = groupeInstance.getId()
        def listePois= sql.rows("SELECT poi_id FROM groupe_pois where groupe_id=$idGroupe")
        def int[] tableauxValeurs = null
        def List<Poi> listePoisNotExist = new ArrayList<>()
        if(listePois!=null && listePois.size()>0)
        {
            tableauxValeurs = new int[listePois.size()]
            def compteur = 0
            listePois.each {
                ligne->
                    //println("listePois disponible " + ligne.poi_id)
                    tableauxValeurs[compteur] = ligne.poi_id
                    compteur++
            }
            compteur = 0
            def String requeteGroupePoisNotGroupe = tableauxValeurs.toString().replace("[", "(").replace("]", ")")
            //println("tableau " + requeteGroupePoisNotGroupe)
            def String requeteExecute = "SELECT poi_id FROM groupe_pois where poi_id not in $requeteGroupePoisNotGroupe"
            //println("requete go  " + requeteExecute)
            def listePoisNotAvailable= sql.rows(requeteExecute)

            if(listePoisNotAvailable!=null && listePoisNotAvailable.size()>0)
            {

                List<Long> listesIdGroupeNonDisponible = new ArrayList<>()
               //* println("listePois non  disponible " + listePoisNotAvailable)
                listePoisNotAvailable.each {
                    ligne->
                        //println("listePois disponible " + ligne.poi_id)
                        listesIdGroupeNonDisponible.add(Long.parseLong(String.valueOf(ligne.poi_id)))
                }
                if(listesIdGroupeNonDisponible.size()>0)
                {
                   listePoisNotExist= Groupe.executeQuery("SELECT p FROM Poi p WHERE p.id in :listePois", [listePois:listesIdGroupeNonDisponible])
                   /*if(listePoisNotExist!=null)
                   {
                       println("taille de la liste " + listePoisNotExist.size())
                   }*/

                }

            }

        }else{
            listePoisNotExist = Poi.findAll()
        }
        return listePoisNotExist
    }
    /**
     * Mise à jour du groupe par ajax
     * @param idGroupe
     * @param idPoi
     * @param operation
     * @return
     */
    def String miseAjourPoisGroupe(long idGroupe, long idPoi, String operation)
    {
        Groupe groupePoi = Groupe.findById(idGroupe)
        Poi poi = Poi.findById(idPoi)
        def String successOperation ="ko"

        if(groupePoi!=null && poi!=null)
        {
            switch (operation){
                case "ok": // ajouter un poi dans un groupe
                    if(!groupePoi.getPois().contains(poi))
                    {
                        groupePoi.addToPois(poi)
                        successOperation ="ok"
                        groupePoi.merge()
                    }

                break

                case "ko": // retrait du poi dans la liste
                    if(groupePoi.getPois().contains(poi))
                    {
                        groupePoi.getPois().remove(poi)
                        successOperation ="ok"
                        groupePoi.merge()
                    }

                break
            }
        }

        return successOperation
    }

    /**
     *
     * @param groupeToRemove
     * @return
     */
    def String supprimerGroupe(def String groupeToRemove)
    {
        def String result = "ko"
        if(groupeToRemove!=null && groupeToRemove.length())
        {
            try{
                Long idGroupe = Long.parseLong(groupeToRemove)
                Groupe groupeManager = Groupe.findById(idGroupe)

                if(groupeManager!=null)
                {
                    if(groupeManager.getImage()!=null)
                    {
                        String name = groupeManager.getImage().getNom()
                        String locationPhysique = grailsApplication.config.grails.projet.gpoi.server.folder.image
                        String name2 = locationPhysique+"$name"
                        boolean resultSupprime  = deleteFileIntoFolder(name2)

                        println("boolean supprime " + resultSupprime)
                        if(resultSupprime)
                        {
                            groupeManager.delete flush:true
                            result="ok"
                        }else{
                            result="ko"
                        }
                    }else{
                        groupeManager.delete flush:true
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
    def List<Groupe> getLisGroupeParProfil(def params)
    {
        List<Groupe> listesGroupes = new ArrayList<>()
        User userCurrent = springSecurityService.getCurrentUser()
        String roleName = roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        switch(roleName)
        {
            case "ROLE_ADMIN":
                params.order="asc"
                params.sort="nom"
                def startIndex = params.offset?:0
                params.offset = startIndex
                listesGroupes = Groupe.list(params)
                break
            case "ROLE_MODERATOR":
                def startIndex = params.offset?:0
                def  limit = params.max
                listesGroupes = Poi.findAll("from Groupe as g where g.user=? order by g.nom, g.dateCreated",
                        [userCurrent], [max:limit, offset:startIndex])
                /*listPois =Poi.findAll([max:limit, offset:startIndex]){
                    user==userCurrent
                }.sort ({name:'asc'})*/
                break

            case "ROLE_USER":
                params.order="asc"
                params.sort="nom"
                def startIndex = params.offset?:0
                params.offset = startIndex
                listesGroupes = Groupe.list(params)
                break
        }
        return listesGroupes
    }

    def int totalCountGroupeByProfil()
    {
        User userCurrent = springSecurityService.getCurrentUser()
        String roleName = roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        def int countElement = 0;
        switch(roleName)
        {
            case "ROLE_ADMIN":
                countElement = Groupe.list().size()
                break
            case "ROLE_MODERATOR":
                countElement = Groupe.findAll("from Groupe as g where g.user=? order by g.nom",[userCurrent]).size()
                break

            case "ROLE_USER":
                countElement = Groupe.list().size()
                break
        }
        return countElement
    }

    /**
     * LISTE POI PAR PROFIL
     */
    def  getLisGroupeParProfilHome()
    {
       // List<Groupe> listesGroupes = new ArrayList<>()
        def listesGroupes
        User userCurrent = springSecurityService.getCurrentUser()
        String roleName = roleService.rechercheDeLaPlusGrandeAuthorityUtilisateur()
        switch(roleName)
        {
            case "ROLE_ADMIN":
                def critere = Groupe.createCriteria()
                listesGroupes = critere.list {
                    and{
                        order("dateCreated", "asc")
                        order("nom", "asc")
                    }
                }
                //listesGroupes = Groupe.list(sort :"dateCreated")
                break
            case "ROLE_MODERATOR":
                listesGroupes = Poi.findAll("from Groupe as g where g.user=? order by g.nom, g.dateCreated",
                        [userCurrent])
                break

            case "ROLE_USER":
                //listesGroupes = Groupe.list(sort :"dateCreated")
                def critere = Groupe.createCriteria()
                listesGroupes = critere.list {
                    and{
                        order("dateCreated", "asc")
                        order("nom", "asc")
                    }

                }
                break
        }
        return listesGroupes
    }

}
