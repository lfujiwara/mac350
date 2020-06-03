const generateUsers = require('./generators/generateUsers')
const fs = require('fs')
const knex = require('knex')({
  client: 'pg',
  connection: {
    host: 'localhost',
    port: '5432',
    user: 'MAC350_2020',
    password: 'MAC350_2020',
    database: 'MAC350_2020',
  },
}).withSchema('exam_tracker')

const USERS_QTY = 25

const main = async () => {
  const query = await knex
    .select(['id_usuario', 'login', 'cpf'])
    .from('usuario')

  const tutors = query.map(x => x.id_usuario)
  const cpfSet = new Set(query.map(x => x.cpf))
  const loginSet = new Set(query.map(x => x.login))

  const generated = generateUsers(USERS_QTY, { cpf: cpfSet, login: loginSet })

  console.log([...cpfSet], [...loginSet])

  const users = generated.users.map(user => ({
    ...user,
    id_tutor: tutors[Math.floor(Math.random() * tutors.length)],
  }))

  const usersFilename = `${__dirname}/dump/insert_users_tutored.sql`

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
      user.id_tutor,
    ]

    const query = `SELECT inserir_usuario(${params
      .map(param => `\'${param.toString().replace("'", "''")}\'`)
      .join(', ')})`

    insertions.push(`${query};`)
  })

  fs.writeFileSync(usersFilename, insertions.join('\n'))
}

main()
