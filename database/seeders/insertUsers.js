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
})

const USERS_QTY = 100

const main = async () => {
  const generated = generateUsers(USERS_QTY)

  const users = generated.users

  const usersFilename = `${__dirname}/dump/insert_users.sql`

  const insertions = ['SET search_path TO mac350_schema;']

  users.forEach(user => {
    const query = knex('usuario').insert(user).toQuery()
    insertions.push(`${query};`)
  })

  fs.writeFileSync(usersFilename, insertions.join('\n'))
}

main()
