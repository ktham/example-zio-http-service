package server

import zio.http
import zio.http.Path
import zio.http.Request
import zio.http.Response
import zio.http.URL
import zio.test.Assertion.equalTo
import zio.test.ZIOSpecDefault
import zio.test.assertZIO

object AppRoutesSpec extends ZIOSpecDefault {
  override def spec = suite("AppRoutes suite")(
    test("GET / should return respond with HTTP 200'") {
      val request = Request.get(URL(Path.decode("/")))
      val zioResponse = AppRoutes.routes.runZIO(request)

      assertZIO(zioResponse)(equalTo(Response.ok))
    },

    test("GET /ping should return 'pong!'") {
      val request = Request.get(URL(Path.decode("/ping")))
      val zioResponse = AppRoutes.routes.runZIO(request)

      assertZIO(zioResponse)(equalTo(Response.text("pong!")))
    },
  )
}
