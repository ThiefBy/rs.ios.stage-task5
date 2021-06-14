import Foundation

class StockMaximize {
    
    func countProfit(prices: [Int]) -> Int {
        var shares:[Int] = [];
        var profit = 0;
        
        for (index, price) in prices.enumerated() {
            let higherPriceInFuture = prices.suffix(from: index+1).first(where: { p in p>price });
            if((higherPriceInFuture) != nil){
                shares+=[price];
            }
            else {
                while shares.count>0 {
                    let ts = shares.popLast();
                    if(ts != nil){
                        profit += (price - ts!)
                    }
                }
            }
        }
        
        return profit
    }
}
