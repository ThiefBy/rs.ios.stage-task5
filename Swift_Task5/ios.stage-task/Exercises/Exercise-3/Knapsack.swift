import Foundation

public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
    let maxWeight: Int
    let drinks: [Supply]
    let foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    fileprivate func getSupplyMatrix(_ supplies: [Supply]) -> [[Int]] {
        var supplyMatrix = Array(repeating: Array(repeating: 0, count: maxWeight + 1), count: supplies.count + 1)
        for i in 1 ... supplies.count {
            let food = supplies[i - 1]
            
            for j in 1 ... maxWeight {
                supplyMatrix[i][j] = food.weight > j
                    ? supplyMatrix[i - 1][j]
                    : max(supplyMatrix[i - 1][j], food.value + supplyMatrix[i - 1][j - food.weight])
            }
        }
        
        return supplyMatrix
    }
    
    func findMaxKilometres() -> Int {
        if (maxWeight > 2500 || maxWeight < 0) {
            return 0
        }
        
        let foodMatrix = getSupplyMatrix(foods)
        let drinksMatrix = getSupplyMatrix(drinks)
        
        var maxKilometers = 0
        for i in 0...maxWeight {
            maxKilometers = max(maxKilometers, min(drinksMatrix[drinks.count][i], foodMatrix[foods.count][maxWeight - i]))
        }
        return maxKilometers
    }
}
