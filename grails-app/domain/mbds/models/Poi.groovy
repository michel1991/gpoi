package mbds.models

class Poi {

    String nom
    String description
    String adresse
    Double latitude
    Double longitude
    Illustration image
    Date dateCreated
    Date lastUpdated
    User user
    String tel

    static constraints = {
        nom blank: false, maxSize: 200
        adresse blank: false, maxSize: 200
        description nullable: true
        image nullable: true
        tel nullable: true
        user nullable: true
        latitude nullable: true
        longitude nullable: true

    }


    static hasMany = [groupes:Groupe]
    // many to many relation
    static belongsTo = Groupe

    static mapping = {
        description type: "text"
        image cascade:"all-delete-orphan"
    }
}
