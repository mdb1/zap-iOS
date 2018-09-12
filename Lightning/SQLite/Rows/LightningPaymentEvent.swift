//
//  Lightning
//
//  Created by Otto Suess on 12.09.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import BTCUtil
import Foundation
import SQLite

/*
 Includes all Payments.
 Inlcudes invoices that have been settled.
 */
struct LightningPaymentEvent {
    let paymentHash: String
    let memo: String?
    let amount: Satoshi // amount + optional fees
    let fee: Satoshi
    let date: Date
}

// SQL
extension LightningPaymentEvent {
    private enum Column {
        static let paymentHash = Expression<String>("paymentHash")
        static let memo = Expression<String?>("memo")
        static let amount = Expression<Satoshi>("amount")
        static let fee = Expression<Satoshi>("fee")
        static let date = Expression<Date>("date")
    }
    
    private static let table = Table("lightningPaymentEvent")
    
    static func createTable(database: Connection) throws {
        try database.run(table.create(ifNotExists: true) { t in
            t.column(Column.paymentHash, primaryKey: true)
            t.column(Column.memo)
            t.column(Column.amount)
            t.column(Column.fee)
            t.column(Column.date)
        })
    }
    
    func insert() throws {
        try SQLiteDataStore.shared.database.run(LightningPaymentEvent.table.insert(
            Column.paymentHash <- paymentHash,
            Column.memo <- memo,
            Column.amount <- amount,
            Column.fee <- fee,
            Column.date <- date)
        )
    }
}
