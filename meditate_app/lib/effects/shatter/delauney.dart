import 'dart:math';

import 'face.dart';
import 'edge.dart';
import 'face_collection.dart';
import 'vertex.dart';

/// Computes a Delaunay triangulation of given points
class DelaunayTriangulation {
  late final Set<Vertex> _vertices;
  late final FaceCollection _faceCollection;
  Set<Edge>? _edges;

  DelaunayTriangulation(Iterable<Vertex> input) {
    final vertices = <Vertex>{}..addAll(input);
    final faceCollection = FaceCollection();

    if (vertices.length < 3) {
      throw Exception('Triangulation with less than 3 points is not possible!');
    }

    final double magnitude =
        vertices.map((v) => max(v.x.abs(), v.y.abs())).reduce(max) * 16.0;

    final omega1 = Vertex(0.0, 3.0 * magnitude);
    final omega2 = Vertex(3.0 * magnitude, 0.0);
    final omega3 = Vertex(-3.0 * magnitude, -3.0 * magnitude);
    final omegaFace = Face(omega1, omega2, omega3);
    faceCollection.add(omegaFace);

    for (var vertex in vertices) {
      final face = faceCollection.findContainingFace(vertex);

      if (face == null) {
        final edge = faceCollection.findNearestEdge(vertex);
        final adjacentFaces = faceCollection.findFacesSharingEdge(edge);

        if (adjacentFaces.length != 2) {
          throw Exception('Edge adjacent to ${adjacentFaces.length} faces!');
        }

        final first = adjacentFaces.first;
        final second = adjacentFaces.last;

        final firstRemainingVertex = first.getRemainingVertex(edge);
        final secondRemainingVertex = second.getRemainingVertex(edge);

        final face1 = Face(edge.p, firstRemainingVertex, vertex);
        final face2 = Face(edge.q, firstRemainingVertex, vertex);
        final face3 = Face(edge.p, secondRemainingVertex, vertex);
        final face4 = Face(edge.q, secondRemainingVertex, vertex);

        faceCollection.remove(first);
        faceCollection.remove(second);

        faceCollection.add(face1);
        faceCollection.add(face2);
        faceCollection.add(face3);
        faceCollection.add(face4);

        _legalizeEdge(
            face1, Edge(edge.p, firstRemainingVertex), vertex, faceCollection);
        _legalizeEdge(
            face2, Edge(edge.q, firstRemainingVertex), vertex, faceCollection);
        _legalizeEdge(
            face3, Edge(edge.p, secondRemainingVertex), vertex, faceCollection);
        _legalizeEdge(
            face4, Edge(edge.q, secondRemainingVertex), vertex, faceCollection);
      } else {
        // Vertex lies within the face
        final a = face.a;
        final b = face.b;
        final c = face.c;

        final first = Face(a, b, vertex);
        final second = Face(b, c, vertex);
        final third = Face(c, a, vertex);

        faceCollection.remove(face);

        faceCollection.add(first);
        faceCollection.add(second);
        faceCollection.add(third);

        _legalizeEdge(first, Edge(a, b), vertex, faceCollection);
        _legalizeEdge(second, Edge(b, c), vertex, faceCollection);
        _legalizeEdge(third, Edge(c, a), vertex, faceCollection);
      }
    }

    faceCollection.removeTrianglesUsing(omega1);
    faceCollection.removeTrianglesUsing(omega2);
    faceCollection.removeTrianglesUsing(omega3);

    // Initialize fields
    _vertices = vertices;
    _faceCollection = faceCollection;
  }

  void _legalizeEdge(
      Face face, Edge edge, Vertex vertex, FaceCollection collection) {
    final neighbouringFace = collection.findNeighbouringFace(face, edge);

    if (neighbouringFace != null &&
        neighbouringFace.liesWithinCircumcircle(vertex)) {
      final noneEdgeVertex = neighbouringFace.getRemainingVertex(edge);

      final firstFace = Face(noneEdgeVertex, edge.p, vertex);
      final secondFace = Face(noneEdgeVertex, edge.q, vertex);

      collection.remove(face);
      collection.remove(neighbouringFace);

      collection.add(firstFace);
      collection.add(secondFace);

      _legalizeEdge(
          firstFace, Edge(noneEdgeVertex, edge.p), vertex, collection);
      _legalizeEdge(
          secondFace, Edge(noneEdgeVertex, edge.q), vertex, collection);
    }
  }

  Set<Vertex> get vertices => _vertices;

  Set<Face> get faces => _faceCollection.faces;

  Set<Edge> get edges {
    _edges ??= faces.map((face) => face.edges).reduce((s, t) => s.union(t));
    return _edges!;
  }

  Face? findContainingFace(Vertex vertex) =>
      _faceCollection.findContainingFace(vertex);

  Set<Face> findFacesSharingEdge(Edge edge) =>
      _faceCollection.findFacesSharingEdge(edge);

  Face? findNeighbouringFace(Face face, Edge edge) =>
      _faceCollection.findNeighbouringFace(face, edge);

  Edge findNearestEdge(Vertex vertex) =>
      _faceCollection.findNearestEdge(vertex);
}
