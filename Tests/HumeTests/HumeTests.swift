import XCTest
@testable import Hume

final class HumeTests: XCTestCase {
    func testSolve1() {
        let a = HunSolver(matrix: [[1,4,6,3],[9,7,10,9],[4,5,11,7],[8,7,8,5]])!
        let res = a.solve()
        var str = "(" + String(res.0) + ", "
        str += res.1.description + ")"
        XCTAssertEqual(str, "(21.0, [(0, 0), (2, 1), (1, 2), (3, 3)])")
    }
    
    func testSolve2() {
        let a = HunSolver(matrix: [[15,5,8,7],[2,12,6,5],[7,8,3,9],[2,4,6,10]])!
        let res = a.solve()
        var str = "(" + String(res.0) + ", "
        str += res.1.description + ")"
        XCTAssertEqual(str, "(15.0, [(3, 0), (0, 1), (2, 2), (1, 3)])")
    }
    
    func testNonSquare() {
        let a = HunSolver(matrix: [[6,7,11],[7,7,5],[12,8,2],[4,11,6]])!
        let res = a.solve()
        var str = "(" + String(res.0) + ", "
        str += res.1.description + ")"
        XCTAssertEqual(str, "(13.0, [(3, 0), (1, 1), (2, 2), (0, 3)])")
    }
    
    func testOneJob() {
        let a = HunSolver(matrix: [[1]])!
        let res = a.solve()
        var str = "(" + String(res.0) + ", "
        str += res.1.description + ")"
        XCTAssertEqual(str, "(1.0, [(0, 0)])")
    }
    
    func testZeroMatrix() {
        let a = HunSolver(matrix: [[0]])!
        let res = a.solve()
        var str = "(" + String(res.0) + ", "
        str += res.1.description + ")"
        XCTAssertEqual(str, "(0.0, [(0, 0)])")
    }
    
    func testEmptyFail() {
        XCTAssertNil(HunSolver(matrix: [[]]))
        XCTAssertNil(HunSolver(matrix: []))
    }
    
    func testNotNaNOrInf() {
        XCTAssertNil(HunSolver(matrix: [[Double.infinity]]))
        XCTAssertNil(HunSolver(matrix: [[Double.nan]]))
        XCTAssertNil(HunSolver(matrix: [[-1]]))
    }
    
    func testMaximize() {
        let a = HunSolver(matrix: [[30,37,40,28,40], [40,24,27,21,36],[40,32,33,30,35],[25,38,40,36,36],[29,62,41,34,49]], maxim: true)
        let res = a!.solve()
        var str = "(" + String(res.0) + ", "
        str += res.1.description + ")"
        XCTAssertEqual(str, "(214.0, [(2, 0), (4, 1), (0, 2), (3, 3), (1, 4)])")
    }
    
    func testMaxUnbalanced() {
        let a = HunSolver(matrix: [[30,37,40,28,40], [40,24,27,21,36],[40,32,33,30,35],[25,38,40,36,36]], maxim: true)
        let res = a!.solve()
        var str = "(" + String(res.0) + ", "
        str += res.1.description + ")"
        XCTAssertEqual(str, "(154.0, [(2, 0), (3, 1), (0, 2), (4, 3), (1, 4)])")
        
    }


    static var allTests = [
        ("testSolve1", testSolve1),
        ("testSolve2", testSolve2),
        ("testNonSquare", testNonSquare),
        ("testOneJob", testOneJob),
        ("testZeroMatrix", testZeroMatrix),
        ("testEmptyFail", testEmptyFail),
        ("testNotNaNOrInf", testEmptyFail),
        ("testMaximize", testMaximize),
        ("testMaxUnbalanced", testMaxUnbalanced)
        
    ]
}
