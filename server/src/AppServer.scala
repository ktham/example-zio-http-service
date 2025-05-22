package server

import org.pkl.config.java.ConfigEvaluator
import org.pkl.core.ModuleSource
import zio.ExitCode
import zio.URIO
import zio.ZIO
import zio.ZIOAppDefault
import zio.ZLayer
import zio.http.Server
import zio.http.Server.live

object AppServer extends ZIOAppDefault {
  private val config = ConfigEvaluator.preconfigured.evaluate(ModuleSource.modulePath("/application.pkl"))

  private val httpInterface = config.get("httpInterface").as(classOf[String])
  private val httpPort = config.get("httpPort").as(classOf[Int])

  override def run: URIO[Any, ExitCode] = {
    val serverConfig = Server.Config.default.binding(httpInterface, httpPort)

    Server.serve(AppRoutes.routes).provide(ZLayer.succeed(serverConfig) >>> live).exitCode
  }
}
