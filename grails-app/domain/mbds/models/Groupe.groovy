package mbds.models

class Groupe {

    String nom
    Date dateCreated
    Date lastUpdated
    Illustration image
    User user
    static constraints = {
        nom blank: false, minSize: 3
        image nullable: true
        user nullable: true
    }


    static hasMany = [pois:Poi]
    static mapping = {
        image cascade:"all-delete-orphan"
    }

}
