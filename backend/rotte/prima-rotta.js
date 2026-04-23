import Fastify from 'fastify'

const fastify = Fastify({
  logger: true
})

async function rotta(fastify, options) {
    fastify.get('/', async (request, reply) => {
        return { hello: 'world' }
    })
}

export default rotta;