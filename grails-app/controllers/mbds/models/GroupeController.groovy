package mbds.models

import grails.plugin.springsecurity.annotation.Secured
import groovy.json.JsonBuilder

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)

class GroupeController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST", ajouterOuSupprimerUnPoi:"POST", listePoisGroupeJson:"POST"]
    def grailsApplication
    def groupeService
    def poiService

    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def listeGroupes = groupeService.getLisGroupeParProfil(params)
        int countElement = groupeService.totalCountGroupeByProfil()
        //respond Groupe.list(params), model:[groupeInstanceCount: Groupe.count()]

        respond listeGroupes, model:[groupeInstanceCount: countElement]
    }

    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def show(Groupe groupeInstance) {
        respond groupeInstance
    }

    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def create() {
        respond new Groupe(params)
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def save(Groupe groupeInstance) {
        if (groupeInstance == null) {
            notFound()
            return
        }


        if (groupeInstance.hasErrors()) {
            respond groupeInstance.errors, view:'create'
            return
        }

        def f=request.getFile('imageUpload')

        Groupe groupeManger = groupeService.creerGroupeAndImage(f, params.nom)
        if(groupeManger!=null)
        {
            flash.successCreation = "ok"
        }else{
            flash.successCreation = "ko"
        }
        redirect action: "create", controller: "groupe"
        //groupeInstance.getPois()
    }

    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def edit(Groupe groupeInstance) {

        //println("groupe " + groupeInstance.getId())
        //groupeService.obtenirPoisNotInGroup(groupeInstance)
        respond groupeInstance, model: [chainePois:groupeService.listePoisGroupeJson(groupeInstance), poisGroupe:groupeService.obtenirPoisGroupe(groupeInstance),poisNotGroupe:groupeService.obtenirPoisNotInGroup(groupeInstance)]
    }

    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    @Transactional
    def update(Groupe groupeInstance) {

        //def int idSend = 0
        //idSend = groupeInstance.getId()

        if (groupeInstance == null) {
            notFound()
            return
        }

        if (groupeInstance.hasErrors()) {
            respond groupeInstance.errors, view:'edit'
            return
        }

       // groupeInstance.save flush:true
        def f=request.getFile('imageUpload')
        def String oldNameString = params.imageVefifUpadte


        String resultOp = "ko"
        resultOp =groupeService.updateGroupe(f, groupeInstance, oldNameString)
        if(resultOp.equals("ko")) // la même photo est renvoyée
        {
            flash.successUpdate = "ko"
        }else if(resultOp.equals("ok")){
            flash.successUpdate = "ok"
        }
        redirect  id:groupeInstance.getId(), action: "edit", controller: "groupe"


    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    def delete(Groupe groupeInstance) {

        if (groupeInstance == null) {
            notFound()
            return
        }

        //groupeInstance.delete flush:true
        def String groupeToRemove = params.valueToRemove
        //println("value id " + groupeToRemove +" other " + groupeInstance.getNom())
        String resultOp = "ko"
        resultOp =groupeService.supprimerGroupe(groupeToRemove)
        if(resultOp.equals("ko")) // la même photo est renvoyée
        {
            flash.successRemove = "ko"
        }else if(resultOp.equals("ok")){
            flash.successRemove = "ok"
        }
        redirect action:"index", controller: "groupe"

    }


    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'groupe.label', default: 'Groupe'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }


    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR'])
    @Transactional
    def ajouterOuSupprimerUnPoi()
    {
        //println("poi " + params.poi_id + " groupe " + params.groupe_id + " op " + params.op)
        String resultatSave ="ko";
        String[] resultat = [1]
        if(params.poi_id!=null && params.groupe_id!=null && params.op!=null)
        {
            if((params.op).length()>0)
            {
                def long poi_id = 0, groupe_id = 0
                def String operation = params.op
                if((params.poi_id).length()>0)
                {
                    poi_id = Long.parseLong(params.poi_id)
                }

                if((params.groupe_id).length()>0)
                {
                    groupe_id = Long.parseLong(params.groupe_id)
                }
                resultatSave = groupeService.miseAjourPoisGroupe(groupe_id, poi_id, operation)
            }

        }

        resultat[0] =  resultatSave
        respond resultat, [formats:['json']]
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR', 'ROLE_USER'])
    def localiserPoiGroupe(Groupe groupeInstance)
    {
        respond groupeInstance, model:[groupeId: groupeInstance.getId()]
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_MODERATOR', 'ROLE_USER'])
    def listePoisGroupeJson()
    {
        def Long groupe_id = 0
        String resultat = ""
        if(params.groupe_id!=null && (params.groupe_id).length()>0)
        {
            try{
                groupe_id = Long.parseLong(params.groupe_id)
                Groupe groupe = Groupe.findById( groupe_id)
                if(groupe!=null)
                {
                    String[] arrayJ = poiService.builJsonsPoiGroupeLocalisation(groupe)
                    resultat = arrayJ.toString()
                }
            }catch (Exception ex){

            }
        }
        //println("resultat " + resultat)
        render resultat
    }

    @Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_MODERATOR'])
    def groupeIndex() {
        def listeGroupes = groupeService.getLisGroupeParProfilHome()
        render(template: "groupeIndexShow", model:[groupes:listeGroupes])
    }
}
