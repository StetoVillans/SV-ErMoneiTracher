import Fastify from 'fastify'
import rotta from './rotte/prima-rotta.js'

const fastify = Fastify({
  logger: true
})

fastify.register(rotta)

// Run the server!
const start = async () => {
  try {
    await fastify.listen({ port: 3000 })
  } catch (err) {
    fastify.log.error(err)
    process.exit(1)
  }
}
start()