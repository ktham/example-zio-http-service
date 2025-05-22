package server

import zio.http.Method
import zio.http.Response
import zio.http.Root
import zio.http.Routes
import zio.http.handler

object AppRoutes {
  val routes = Routes(
    Method.GET / Root -> handler(Response.ok),
    Method.GET / "ping" -> handler(Response.text("pong!")),
  ).sandbox
}
