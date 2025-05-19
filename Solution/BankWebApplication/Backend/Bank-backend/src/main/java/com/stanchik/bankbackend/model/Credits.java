package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Credits", schema = "admin_user")
public class Credits {
    public enum Status {
        Active,
        Paid,
        Expired,
        Canceled,
        Pending
    };
    public enum PaymentFrequency {
        ONCE_A_MONTH("Once a month"),
        ONCE_EVERY_THREE_MONTHS("Once every three months"),
        ONCE_EVERY_SIX_MONTHS("Once every six months");

        private final String value;
        PaymentFrequency(String value) {
            this.value = value;
        };

        @Override
        public String toString() {
            return value;
        };
    };

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "CREDIT_TYPE_ID", nullable = false)
    private CreditType creditType;

    @ManyToOne
    @JoinColumn(name = "ACCOUNT_ID", nullable = false)
    @Column(name = "ACCOUNT_ID", precision = 10, columnDefinition = "number(10)")
    private UserAccount accountId;

    @Column(name = "AMOUNT", nullable = false, precision = 15, scale = 2, columnDefinition = "number(15, 2)")
    private BigDecimal amount;

    @Column(name = "ISSUED_DATE", columnDefinition = "date")
    private Date issuedDate;

    @Column(name = "MATURITY_DATE", columnDefinition = "date")
    private Date maturityDate;

    @Column(name = "INTEREST_RATE", precision = 5, scale = 2, columnDefinition = "number(5, 2)")
    private BigDecimal interestDate;

    @Column(name = "DEBT_AMOUNT", precision = 15, scale = 2, columnDefinition = "number(15, 2)")
    private BigDecimal debtAmount;

    @Column(name = "REMAINING_AMOUNT", precision = 15, scale = 2, columnDefinition = "number(15, 2)")
    private BigDecimal remainingAmount = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(name = "STATUS", length = 8, columnDefinition = "char(8)")
    private Status status;

    @ManyToOne
    @JoinColumn(name = "CURRENCY_ID", nullable = false)
    @Column(name = "CURRENCY_ID", columnDefinition = "number(3)", precision = 3)
    private Currency currencyId;

    @Column(name = "PAYMENT_AMOUNT", precision = 15, scale = 2)
    private BigDecimal paymentAmount = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(name = "PAYMENT_FREQUENCY", length = 30, columnDefinition = "varchar2(30)")
    private PaymentFrequency paymentFrequency;

    @Column(name = "LOAN_TERM", columnDefinition = "number")
    @Min(1)
    @Max(15)
    private Integer loanTerm;

    @Column(name = "LOAN_PURPOSE", length = 255, columnDefinition = "varchar2(255)")
    private String loanPurpose;

    @Column(name = "TOTAL_AMOUNT", precision = 15, scale = 2, columnDefinition = "number(15, 2)")
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Min(1)
    @Max(28)
    @Column(name = "PAYMENT_DAY", columnDefinition = "number")
    private Integer paymentDay;

};
