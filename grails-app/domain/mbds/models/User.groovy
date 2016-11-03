package mbds.models

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

	private static final long serialVersionUID = 1

	transient springSecurityService

	String username
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	String emailUser
	String tel
	String confirmPassword
	String messageErrorMotDePasse


	User(String username, String password) {
		this()
		this.username = username
		this.password = password
	}


	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this)*.role
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}

	static transients = ['springSecurityService', 'confirmPassword', 'messageErrorMotDePasse']

	static hasMany = [pois:Poi, groupes:Groupe]
	static constraints = {
		username blank: false, unique: true
		password blank: false, minSize: 4
		confirmPassword blank: false, minSize: 4

		tel blank: false, nullable: false, matches: '\\d{10}'
		emailUser email: false, nullable: false, unique: true
	}

	static mapping = {
		password column: '`password`'
		groupes cascade:"all-delete-orphan"
		pois cascade: "all-delete-orphan"
	}
}
