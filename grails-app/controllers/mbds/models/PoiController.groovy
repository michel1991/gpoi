package mbds.models

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.codehaus.groovy.grails.web.json.JSONArray

import java.util.regex.Pattern
import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class PoiController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST", poiByFormatJson:"POST"]
    def grailsApplication
    def poiService
    def illustrationService

    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def listePoi = poiService.getLisPoiParProfil(params)
       // println("offset ***" + params.offset + " result " + listePoi.size())
        int countElement = poiService.totalCountPoiByProfil()
        respond listePoi, model:[poiInstanceCount: countElement]
    }

    def show(Poi poiInstance) {
        respond poiInstance
    }

    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def create() {

        //println("resultat " + b)
        respond new Poi(params)
    }

    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    @Transactional
    def save(Poi poiInstance) {
        if (poiInstance == null) {
            notFound()
            return
        }

        String[] groupesIdClient = params.groupe_id
        def listeGroupesBd
        def chaineCoteClientPourIdGroupes = ""

        if(groupesIdClient!=null &&  groupesIdClient.length>0)
        {
            chaineCoteClientPourIdGroupes = groupesIdClient.toString().replace("[","").replace("]","")
            listeGroupesBd = poiService.obtenirLaListeDesGroupes(groupesIdClient)
        }

        boolean b = Pattern.matches("\\d{10}", poiInstance.getTel())

        if(b==false)
        {
            poiInstance.errors.reject('error.tel', ['tel', 'class Poi'] as Object[], 'invalide')
            poiInstance.errors.rejectValue('tel', 'error.tel')
        }


        String localisation = params.locationPoi
        println("localistaion " +params.locationPoi)
        String[] localisations
        if(localisation !=null && localisation .length()>0)
        {
            localisations = localisation.split(";")
            if(localisations!=null && localisations.length==2)
            {
                poiInstance.setLatitude(Double.parseDouble(localisations[0]))
                poiInstance.setLongitude(Double.parseDouble(localisations[1]))
                //println("localistaion show latitude" +poiInstance.getLatitude())
            }
        }
        if (poiInstance.hasErrors()) {
            respond poiInstance.errors, view:'create', model: [groupeCoches:chaineCoteClientPourIdGroupes]
            return
        }

        def f=request.getFile('imageUpload')
        boolean flatSaveImage = true
        Illustration image =null
        if(f!=null)
        {
            image = illustrationService.enregistrerImage(f)
            if(image!=null)
            {
                flash.successCreation = "ok"
            }else{
                String locationPhysique = grailsApplication.config.grails.projet.gpoi.server.folder.image
                String location = locationPhysique+"$image.getNom()"
                File file =null
                try{
                    file = new File(location)
                    if(file.exists())
                    {
                        file.delete()
                    }
                }catch(NullPointerException exception)
                {
                    println("impossible de supprimer votre image poi controller poi methode save " )
                }
                flash.successCreation = "ko"
                flatSaveImage = false
            }
        }
        if(flash.successCreation=="ko")
        {
            respond poiInstance.errors, view:'create', model: [groupeCoches:chaineCoteClientPourIdGroupes]
            return
        }

        if(flash.successCreation=="ok")
        {
            poiService.enregisterPoi(image, poiInstance, listeGroupesBd)
            flash.successCreation = "ok"
        }


        //poiInstance.save flush:true
        redirect action: "create", controller: "poi"
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def edit(Poi poiInstance) {
        def chaineCoteClientPourIdGroupes = poiService.updateListeGroupePoi(poiInstance)
        respond poiInstance, model:[groupeCoches:chaineCoteClientPourIdGroupes]
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def update(Poi poiInstance) {
        if (poiInstance == null) {
            notFound()
            return
        }


        String[] groupesIdClient = params.groupe_id
        def listeGroupesBd
        def chaineCoteClientPourIdGroupes = ""

        if(groupesIdClient!=null &&  groupesIdClient.length>0)
        {
            chaineCoteClientPourIdGroupes = groupesIdClient.toString().replace("[","").replace("]","")
            listeGroupesBd = poiService.obtenirLaListeDesGroupes(groupesIdClient)
        }

        boolean b = Pattern.matches("\\d{10}", poiInstance.getTel())
        if(b==false)
        {
            poiInstance.errors.reject('error.tel', ['tel', 'class Poi'] as Object[], 'invalide')
            poiInstance.errors.rejectValue('tel', 'error.tel')
        }

        String localisation = params.locationPoi
        println("localistaion " +params.locationPoi)
        String[] localisations
        if(localisation !=null && localisation .length()>0)
        {
            localisations = localisation.split(";")
            if(localisations!=null && localisations.length==2)
            {
                poiInstance.setLatitude(Double.parseDouble(localisations[0]))
                poiInstance.setLongitude(Double.parseDouble(localisations[1]))
                //println("localistaion show latitude" +poiInstance.getLatitude())
            }
        }
        if (poiInstance.hasErrors()) {
            respond poiInstance.errors, view:'edit', model: [groupeCoches:chaineCoteClientPourIdGroupes]
            return
        }
        def f=request.getFile('imageUpload')
        def String oldNameString = params.imageVefifUpadte
        String resultOp = "ko"

        resultOp =poiService.updatePoi(f,poiInstance, oldNameString, listeGroupesBd)
        if(resultOp.equals("ko")) // la même photo est renvoyée
        {
            flash.successUpdate = "ko"
        }else if(resultOp.equals("ok")){
            flash.successUpdate = "ok"
        }
        redirect  id:poiInstance.getId(), action: "edit", controller: "poi"
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR', 'ROLE_USER'])
    def localiserPoi(Poi poiInstance)
    {
        respond poiInstance, model:[poiId: poiInstance.getId()]
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR', 'ROLE_USER'])
    def testJosn()
    {
        Poi poiInstance = Poi.findById(new Long(1))
        Groupe groupe = Groupe.findById(new Long(1))
        def json = poiService.builJsonPoiLocalisation(poiInstance)
        String[] arrayJ = poiService.builJsonsPoiGroupeLocalisation(groupe)
        println("size " +arrayJ.size())
        render  arrayJ.toString()
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR', 'ROLE_USER'])
    def poiByFormatJson()
    {
        def Long poi_id = 0
        String resultat = ""
        if(params.poi_id!=null && (params.poi_id).length()>0)
        {
           // println("poi_id " + params.poi_id)
            try{
                poi_id = Long.parseLong(params.poi_id)
                Poi poiInstance =Poi.findById(poi_id)
                if(poiInstance!=null)
                {
                    resultat = poiService.builJsonPoiLocalisation(poiInstance)
                }
            }catch (Exception ex){

            }
        }
        //println("resultat " + resultat)
        render resultat
    }



    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def delete(Poi poiInstance) {

        if (poiInstance == null) {
            notFound()
            return
        }

        //poiInstance.delete flush:true

        def String groupeToRemove = params.valueToRemove
       // println("value id " + groupeToRemove +" other ")
        String resultOp = "ko"
        resultOp =poiService.supprimerPoi(groupeToRemove)
        if(resultOp.equals("ko")) // la même photo est renvoyée
        {
            flash.successRemove = "ko"
        }else if(resultOp.equals("ok")){
            flash.successRemove = "ok"
        }


        redirect action:"index", controller: "poi"
    }
    @Transactional
    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def exempeModif() {
        Poi poi = new Poi()
        respond poi
    }
    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'poi.label', default: 'Poi'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
