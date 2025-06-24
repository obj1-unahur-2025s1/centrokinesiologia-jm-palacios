import wollok.vm.*
class Paciente{
  var edad
  var fortalezaM
  var dolor
  const rutina = []
  
  method cumplirAnios(){edad +=1}
  method edad() =edad
  method fortalezaM() = fortalezaM
  method dolor() = dolor
  method nuevoDolor(unValor){dolor = (dolor - unValor).max(0)}
  method nuevaFortalezaM(unValor){fortalezaM = fortalezaM + unValor}
  method puedeUsarAparato(unAparato) = unAparato.puedeSerUsado(self)
  method usarAparato(unAparato){
    if (self.puedeUsarAparato(unAparato)){
      unAparato.usar(self)
    }
  }
  method puedeRealizarRutina() = rutina.all({a =>self.puedeUsarAparato(a)})
  method realizarSesion(){
    if(self.puedeRealizarRutina()){
      rutina.forEach({a =>self.usarAparato(a)})
    }
  }
  method asignarEnRutina(unAparato){rutina.add(unAparato)}
}
class Resistente inherits Paciente {
  method cantAparatos() = rutina.size()
  override method realizarSesion(){
    super()
    self.nuevaFortalezaM(self.cantAparatos())
  }  
}
class Caprichoso inherits Paciente {
  override method puedeRealizarRutina() = super() and rutina.any({a =>a.color()=='rojo'})
  override method realizarSesion(){
    super()
    super()
  }
}
class RapidaRecuperacion inherits Paciente {
  var recuperacion = 3
  method nuevaRecuperacion(unValor){recuperacion = unValor}
  override method realizarSesion(){
    super()
    dolor = (dolor - recuperacion).max(0)
  }    
}
class Magneto{
  var imantacion = 800
  var property color = 'blanco'
  method puedeSerUsado(unPaciente) = true
  method usar(unPaciente) {
    unPaciente.nuevoDolor(unPaciente.dolor()*0.1) 
    imantacion = (imantacion - 1).max(0)   
  }
  method necesitaMantenimiento() = imantacion < 100
  method mantenimiento() {imantacion = imantacion + 500}  
}
class Bicicleta {
  var pierdeAceite = 0
  var desajusteTornillos = 0
  var property color = 'blanco'
  method puedeSerUsado(unPaciente) = unPaciente.edad() > 8
  method usar(unPaciente){
    if (unPaciente.dolor() > 30){
      pierdeAceite +=1
    }
    if (unPaciente.edad().between(30, 50)){
      desajusteTornillos += 1
    }
    unPaciente.nuevoDolor(4)
    unPaciente.nuevaFortalezaM(3)
  }  
  method necesitaMantenimiento() = (pierdeAceite >=5) or (desajusteTornillos>=10)
  method mantenimiento() {
    pierdeAceite = 0
    desajusteTornillos = 0}
}
class MiniTramp {
  var property color = 'blanco'
  method puedeSerUsado(unPaciente) = unPaciente.dolor() < 20
  method usar(unPaciente){
    unPaciente.nuevaFortalezaM(unPaciente.edad()*0.1)
  }  
  method necesitaMantenimiento() = false
  method mantenimiento() {}
}
object centro {
  const aparatos = []
  const pacientes = #{}
  method incluirAparatos(unosAparatos) {aparatos.addAll(unosAparatos)}
  method ingresarPacientes(unPaciente) {pacientes.add(unPaciente)}
  method colorAparatos() =  aparatos.map({a =>a.color()}).asSet()
  method pacientesMenoresDe(unaEdad) = pacientes.filter({p =>p.edad()<unaEdad})
  method pacientesQueNoPuedeHacerRutina() = pacientes.filter({p =>!p.puedeRealizarRutina()})
  method estaOptimaCondiciones() = aparatos.all({a =>!a.necesitaMantenimiento()}) 
  method aparatosQueNecesitaMantenimiento() = aparatos.filter({a =>a.necesitaMantenimiento()}) 
  method estacomplicado() = self.aparatosQueNecesitaMantenimiento().size()>=aparatos.size()/2
  method visitaTecnica() {
    self.aparatosQueNecesitaMantenimiento().forEach({a =>a.mantenimiento()})    
  } 
}