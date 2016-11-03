package mbds.models

import grails.transaction.Transactional

import java.text.SimpleDateFormat

@Transactional
class IllustrationService {

    def grailsApplication

    def springSecurityService

    def Illustration enregistrerImage(def f)
    {
        def userCurrent = springSecurityService.getCurrentUser()
        Date now = new Date()
        SimpleDateFormat timestamp = new SimpleDateFormat("yyyyMMddHHmmss")
        def nameHashFile = timestamp.format(now)
        def fos= null
        boolean verifOperation = true
        Illustration imageIllustration = null

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
                 imageIllustration = new Illustration(nom:name, user:userCurrent)
                //imageIllustration.save(failOnError: true, flush: true)
            }
        }
        return imageIllustration
    }
}
