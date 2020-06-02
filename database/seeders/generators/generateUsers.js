const faker = require('faker')
const bcrypt = require('bcrypt')
const gcpf = require('cpf')
const fs = require('fs')

const areas_de_pesquisa = require('../assets/areas_de_pesquisa')
const universidades = require('../assets/universidades')

const unique = {
  cpf: new Set(),
  login: new Set(),
}

const generateUser = () => {
  let cpf = gcpf.generate(false)
  while (unique.cpf.has(cpf)) cpf = gcpf.generate(false)

  let firstName = faker.name.firstName(),
    lastName = faker.name.lastName()
  let login = faker.internet.userName(firstName, lastName)
  while (unique.login.has(login)) {
    ;(firstName = faker.name.firstName()), (lastName = faker.name.lastName())
    login = faker.internet.userName(firstName, lastName)
  }

  return {
    cpf,
    nome: `${firstName} ${lastName}`,
    area_de_pesquisa:
      areas_de_pesquisa[Math.floor(Math.random() * areas_de_pesquisa.length)],
    instituicao:
      universidades[Math.floor(Math.random() * universidades.length)],
    data_de_nascimento: faker.date.between('1960-01-01', '1999-12-31'),
    login,
    senha: bcrypt.hashSync(faker.internet.password(15), 10),
  }
}

const generateUsers = (
  qty = 500,
  uniqueSet = { cpf: new Set(), login: new Set() }
) => {
  unique.cpf.add(...uniqueSet.cpf)
  unique.login.add(...uniqueSet.login)

  return {
    users: [...Array(qty).keys()].map(() => generateUser()),
    unique,
  }
}

module.exports = generateUsers
