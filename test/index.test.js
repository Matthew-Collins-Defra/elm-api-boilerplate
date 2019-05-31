const createServer = require('../server')

let server

// Create server before each test
beforeEach(async () => {
  server = await createServer()
})

describe('API test', () => {
  test('GET / route works', async () => {
    const options = {
      method: 'GET',
      url: '/'
    }

    const response = await server.inject(options)
    expect(response.statusCode).toEqual(200)
    expect(response.result).toMatchObject({ hello: 'world' })
  })

  test('GET /viewcount route works', async () => {
    const options = {
      method: 'GET',
      url: '/viewcount'
    }

    const response = await server.inject(options)
    expect(response.statusCode).toEqual(200)
    expect(response.result.viewcount).toEqual(1)
  })

  test('GET /viewcount increases', async () => {
    const options = {
      method: 'GET',
      url: '/viewcount'
    }

    const response = await server.inject(options)
    expect(response.statusCode).toEqual(200)
    expect(response.result.viewcount).toEqual(1)

    const secondresponse = await server.inject(options)
    expect(secondresponse.statusCode).toEqual(200)
    expect(secondresponse.result.viewcount).toEqual(response.result.viewcount + 1)
  })

  test('GET unknown route returns 404 error with statusCode, error, and message', async () => {
    const options = {
      method: 'GET',
      url: '/noSuchRoute'
    }

    const response = await server.inject(options)
    expect(response.statusCode).toEqual(404)
    expect(response.result.statusCode).toEqual(404)
    expect(response.result.error).toBe('Not Found')
    expect(response.result.message).toBe('Not Found')
  })
})
