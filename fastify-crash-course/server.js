const fastify = require('fastify')({ logger: true })

const PORT = 5000;

fastify.register(require('./routes/items'))
/* fastify.register(require('@fastify/swagger'), {
    exposeRoute: true,
    routePrefix: '/docs',
    swagger: {
        info: { title: 'fastify-api'},
    },
}) */

fastify.register(require('@fastify/swagger'), {
  openapi: {
    openapi: '3.0.0',
    info: {
      title: 'Test swagger',
      description: 'Testing the Fastify swagger API',
      version: '0.1.0'
    },
    servers: [
      {
        url: 'http://localhost:5000',
        description: 'Development server'
      }
    ],
    tags: [
      { name: 'user', description: 'User related end-points' },
      { name: 'code', description: 'Code related end-points' }
    ],
    components: {
      securitySchemes: {
        apiKey: {
          type: 'apiKey',
          name: 'apiKey',
          in: 'header'
        }
      }
    },
    externalDocs: {
      url: 'https://swagger.io',
      description: 'Find more info here'
    }
  }
})

fastify.register(require('@fastify/swagger-ui'), {
  routePrefix: '/docs'
})

const start = async () => {
    try {
        await fastify.ready()
        await fastify.listen({port: PORT})
    } catch (error) {
        fastify.log.error(error)
        process.exit(1)
    }
}

start()