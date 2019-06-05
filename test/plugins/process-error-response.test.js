const processErrorResponse = require('../../server/plugins/process-error-response')

function createRequest (statusCode, data, message) {
  const logs = []
  return {
    response: {
      data,
      message,
      output: {
        statusCode
      }
    },
    log: (type, info) => logs.push({ type, info }),
    logs
  }
}

describe('process error response', () => {
  test('logs non 404 errors', async () => {
    const statusCode = 500
    const data = { status: 'server error' }
    const message = 'Action failed'
    const request = createRequest(statusCode, data, message)
    const response = processErrorResponse(request)
    expect(request.logs.length).toEqual(1)
    expect(request.logs[0]).toMatchObject({
      type: 'error',
      info: { statusCode, data, message }
    })
    expect(response).toEqual(request.response)
  })

  test('does not log 404 errors', async () => {
    const statusCode = 404
    const data = { status: 'user error' }
    const message = 'Page not found'
    const request = createRequest(statusCode, data, message)
    const response = processErrorResponse(request)
    expect(request.logs.length).toEqual(0)
    expect(response).toEqual(request.response)
  })
})
