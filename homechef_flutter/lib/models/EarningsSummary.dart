class EarningsSummary {
    int balance;
    int earnings_this_month;
    LatestPayment last_payment;

    EarningsSummary(this.balance, this.earnings_this_month, this.last_payment);

    Map<String, dynamic> toJson() => {
        'balance': balance,
        'earnings_this_month': earnings_this_month,
        'last_payment': last_payment
    };

    EarningsSummary.fromJson(Map<String, dynamic> json)
        :   balance = json['balance'].round(),
            earnings_this_month = json['earnings_this_month'],
            last_payment = LatestPayment.fromJson(json['last_payment']);
}

class LatestPayment {
    int amount;
    String notes;
    String date;

    LatestPayment(this.amount, this.notes, this.date);

    Map<String, dynamic> toJson() => {
        'amount': amount,
        'notes': notes,
        'date': date
    };

    LatestPayment.fromJson(Map<String, dynamic> json)
        :   amount = json['amount'],
            notes = json['notes'],
            date = json['date'];
}