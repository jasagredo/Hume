import Upsurge

public class HunSolver {
    private var matriz: Matrix<Double>
    private var match: [Int]
    private var vis: [Bool]
    private var adjM: [[Int]]
    private var zeros: [(Int, Int)]
    
    // Inicialización
    // Coste: O(n^2)
    public init(matriz:[[Double]]){
        self.match = [Int]()
        self.vis = [Bool]()
        self.adjM = [[Int]]()
        self.zeros = [(Int, Int)]()
        let f = matriz.count
        let c = matriz[0].count
        let n = max(f,c)
        self.matriz = Matrix(rows: n, columns: n, repeatedValue: 0)
        for i in 0...n {
            if i < f {
                for j in 0...n {
                    if j < c {
                        assert(matriz[i][j] >= 0 && matriz[i][j] < Double.infinity)
                        self.matriz[i,j] = matriz[i][j]
                    }
                }
            }
        }
    }
    
    // Resolución del problema de asignación
    // Coste: O(n^3)
    public func resuelve() -> (Double, [(Int, Int)]){
        var matrizResultado = self.matriz.copy()
        // 1: Restar los mínimos de cada fila
        for i in 0..<self.matriz.rows {
            let mi_minimo = matrizResultado.row(i).min()
            for j in 0..<self.matriz.columns {
                matrizResultado[i,j] -= mi_minimo!
            }
        }
        
        // 2: Restar los mínimos de cada columna
        let costesT = (self.matriz)′
        matrizResultado = (matrizResultado)′
        
        for i in 0..<costesT.rows {
            let mi_minimo = matrizResultado.row(i).min()
            for j in 0..<costesT.columns {
                matrizResultado[i,j] -= mi_minimo!
            }
        }
        matrizResultado = (matrizResultado)′
        
        // 3: Obtener el máximo emparejamiento en la matriz de costes reducidos.
        var pos = [(Int,Int)] ()
        // Necesariamente en cada vuelta se suma al menos uno al numero de emparejamientos así que este bucle da O(n) vueltas
        while (pos.count < self.matriz.rows){
            pos = obtenerEmparejamiento(matriz: matrizResultado)
            if pos.count < self.matriz.rows {
                // 4: Restar el minimo en los no tachados y sumar el minimo en los tachados dos veces. Volver a 3 si no tenemos tantos emparejamientos como trabajos
                matrizResultado = reajustarMatriz(matrizResultado, pos)
            }
            
        }
        
        // 5: Obtener el valor del potencial
        var resultado:Double = 0
        for (i,j) in pos {
            resultado += self.matriz[i,j]
        }
        return (resultado, pos)
    }
    
    
    // Crear las líneas de la bipartición y sumar el minimo a los tachados dos veces y restarselo a los no tachados
    // O(n^2)
    private func reajustarMatriz(_ mat: Matrix<Double>, _ marcados: [(Int,Int)]) -> Matrix<Double> {
        var filas = [[Int]](repeating: [Int](repeating: 0, count: mat.rows), count: mat.rows)
        var columnas = [[Int]](repeating: [Int](repeating: 0, count: mat.rows), count: mat.rows)
        var f_marc = [Bool](repeating: false, count: mat.rows)
        var c_marc = [Bool](repeating: false, count: mat.rows)
        
        for elem in self.zeros {                                                        // O(n^2)
            filas[elem.0][elem.1] = 1
            columnas[elem.1][elem.0] = 1
        }
        
        for elem in marcados {                                                          // O(n)
            filas[elem.0][elem.1] = 2
            columnas[elem.1][elem.0] = 2
        }
        
        for i in 0..<mat.rows {                                                         // O(n)
            if filas[i].max()! < 2 && !f_marc[i] {
                f_marc[i] = true
                if filas[i].max()! == 1 {
                    let idx = filas[i].indices.filter { filas[i][$0] == 1  }
                    for e in idx {
                        filas[i][e] = 3
                        columnas[e][i] = 3
                    }
                }
            }
        }
        var auxf = f_marc
        var auxc = c_marc
        
        while true {                                                                    // O(n) * O(cuerpo) = O(n^2)
            
            for i in 0..<mat.rows {                                                             // O(n)
                if columnas[i].max()! == 3 {
                    c_marc[i] = true
                    let idx = columnas[i].indices.filter { columnas[i][$0] == 2  }
                    for e in idx {
                        filas[e][i] = 0
                        columnas[i][e] = 0
                    }
                }
            }
            
            for i in 0..<mat.rows {                                                             // O(n)
                if filas[i].max()! < 2 && !f_marc[i] {
                    f_marc[i] = true
                    if filas[i].max()! == 1 {
                        let idx = filas[i].indices.filter { filas[i][$0] == 1  }
                        for e in idx {
                            filas[i][e] = 3
                            columnas[e][i] = 3
                        }
                    }
                }
            }
            if auxf == f_marc && auxc == c_marc {
                break
            } else {
                auxf = f_marc
                auxc = c_marc
            }
        }
        
        var minimo = Double.infinity
        for i in 0..<mat.rows {                                                         // O(n^2)
            if f_marc[i]{
                for j in 0..<mat.rows {
                    if !c_marc[j] && mat[i,j] < minimo {
                        minimo = mat[i,j]
                    }
                }
            }
        }
        for i in 0..<mat.rows {                                                         // O(n^2)
            if f_marc[i]{
                for j in 0..<mat.rows{
                    mat[i,j] -= minimo
                }
            }
            if !c_marc[i]{
                for j in 0..<mat.rows{
                    mat[j,i] -= minimo
                }
            }
        }
        for i in 0..<mat.rows {                                                         // O(n^2)
            for j in 0..<mat.rows {
                mat[i,j] += minimo
            }
        }
        
        return mat
    }
    
    private func augment(_ l: Int) -> Int {
        if self.vis[l] {
            return 0
        }
        self.vis[l] = true
        for i in 0..<self.adjM[l].count {
            let r = adjM[l][i]
            if self.match[r] == -1 || augment(self.match[r]) == 1 {
                self.match[r] = l
                return 1
            }
        }
        return 0
    }
    
    // Obtener emparejamiento
    // Mediante algoritmo de Competitive Programming 4.7.4
    // Coste: O(VE)
    private func obtenerEmparejamiento(matriz mat: Matrix<Double>) -> [(Int, Int)] {
        var MCBM = 0
        self.adjM = [[Int]]()
        self.zeros = [(Int,Int)]()
        for i in 0..<mat.rows {
            self.adjM.append([])
            for j in 0..<mat.rows {
                if mat[i,j] == 0 {
                    self.adjM[i].append(j + mat.rows)
                    self.zeros.append((i,j))
                }
            }
        }
        self.match = [Int](repeating: -1, count: mat.rows*2)
        for l in 0..<mat.rows {
            self.vis = [Bool](repeating: false, count: mat.rows)
            MCBM += augment(l)
        }
        var posiciones = [(Int,Int)]()
        for i in mat.rows..<mat.rows*2 {
            if self.match[i] != -1 {
                posiciones.append((self.match[i], i-mat.rows))
            }
        }
        return(posiciones)
    }
}

