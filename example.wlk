class Empleado{
  var salud
  const property habilidades = []
  const subordinados = []
  var tipo
  method incapacitado() = salud <= tipo.saludCritica()
  method sobrevivio() = salud > 0
  method puedeUsar(habilidad) = not self.incapacitado() and (habilidades.contains(habilidad) or subordinados.any({ s => s.puedeUsar(habilidad) }))

  method recibirDaño(daño){
    salud =  0.max(salud - daño)
  }
  method completarMision(habilidadesDeLaMision) {
		if (self.sobrevivio()) tipo.completarMision(self, habilidadesDeLaMision)
	}
  method aprender(habilidadesNuevas) {
		habilidades.addAll(habilidadesNuevas.filter({ h => not habilidades.contains(h) }))
	}
}
object espia {
  method saludCritica() = 15
  method completarMision(empleado, habilidadesDeLaMision) {
		empleado.aprender(habilidadesDeLaMision)
	}
}
class Oficinista{
  var estrellas
  method saludCritica() = 40-5*estrellas
  method completarMision(empleado, habilidadesDeLaMision) {
		estrellas = estrellas + 1
		if (estrellas >= 3) empleado.tipo(espia)
	}
}
class Equipo{
  const integrantes = []
  
	method puedeUsar(habilidad) = integrantes.any({ i => i.puedeUsar(habilidad) })
  method recibirDaño(daño){
    integrantes.forEach({i=>i.salud(0.max(i.salud()-(daño/3)))})
  }
  method completarMision(habilidadesDeLaMision) {
		integrantes.forEach({ i => i.completarMision(habilidadesDeLaMision) })
	}
}
class mision{
  const habilidadesRequeridas = []
  const peligro
  method serCumplidaPor(cumplidor) {
		if (not self.puedeSerCumplidaPor(cumplidor)) self.error("No reune las habilidades requeridas")
		cumplidor.recibirDaño(peligro)
		cumplidor.completarMision(habilidadesRequeridas)
	}
  method puedeSerCumplidaPor(cumplidor) = habilidadesRequeridas.all({ h => cumplidor.puedeUsar(h) })
}