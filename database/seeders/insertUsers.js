const generateUsers = require('./generators/generateUsers')
const fs = require('fs')
const knex = require('knex')({
  client: 'pg',
  connection: {
    host: 'localhost',
    port: '5432',
    user: 'mac350_2020',
    password: 'mac350_2020',
    database: 'mac350_2020',
  },
})

const USERS_QTY = 100
const TUTORED_USERS_QTY = 25

const main = async () => {
  const generated = generateUsers(USERS_QTY)

  const users = generated.users

  const usersFilename = `${__dirname}/dump/insert_users.sql`

  const insertions = ['SET search_path TO exam_tracker;']

  users.forEach(user => {
    const params = [
      user.cpf,
      user.nome,
      user.area_de_pesquisa,
      user.instituicao,
      user.data_de_nascimento.toISOString(),
      user.login,
      user.senha,
    ]

    const query = knex.raw(
      `SELECT inserir_usuario(${params
        .map(param => `\'${param.toString().replace("'", "''")}\'`)
        .join(', ')})`
    )
    insertions.push(`${query};`)
  })

  const tutors = users.map(user => user.cpf)

  const generated_tutored = generateUsers(TUTORED_USERS_QTY, {
    cpf: new Set(...tutors),
    login: new Set(...users.map(x => x.login)),
  })

  const tutoredUsers = generated_tutored.users.map(user => ({
    ...user,
    id_tutor: tutors[Math.floor(Math.random() * tutors.length)],
  }))

  tutoredUsers.forEach(user => {
    const params = [
      user.cpf,
      user.nome,
      user.area_de_pesquisa,
      user.instituicao,
      user.data_de_nascimento.toISOString(),
      user.login,
      user.senha,
      user.id_tutor,
    ]

    const query = `SELECT inserir_usuario_tutorcpf(${params
      .map(param => `\'${param.toString().replace("'", "''")}\'`)
      .join(', ')})`

    insertions.push(`${query};`)
  })

  fs.writeFileSync(usersFilename, insertions.join('\n'))
}

main()
