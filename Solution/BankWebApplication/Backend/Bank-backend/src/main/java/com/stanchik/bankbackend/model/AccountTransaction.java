package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Account_Transaction", schema = "admin_user")
public class AccountTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "ACCOUNT_ID_FROM", nullable = false, columnDefinition = "number(10)")
    private Integer accountIdFrom;

    @Column(name = "ACCOUNT_ID_TO", nullable = false, columnDefinition = "number(10)")
    private Integer accountIdTo;

    @Column(name = "AMOUNT", nullable = false, columnDefinition = "number(15, 2)")
    private BigDecimal amount;

    @Column(name = "DATE_TIME", nullable = false, columnDefinition = "timestamp")
    private Timestamp dateTime;

    @ManyToOne
    @JoinColumn(name = "CURRENCY_ID", nullable = true)
    @Column(name = "CURRENCY_ID", columnDefinition = "number(10)")
    private Currency currencyId;

};
