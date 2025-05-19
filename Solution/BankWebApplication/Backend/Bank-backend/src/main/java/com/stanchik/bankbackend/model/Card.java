package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Card", schema = "admin_user")
public class Card {
    public enum Status {
        Active,
        Blocked;
    };

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "ACCOUNT_ID", nullable = false, columnDefinition = "number(10)")
    private Integer accountId;

    @Column(name = "CARD_NAME", length = 100, columnDefinition = "nvarchar2(100)")
    private String cardName;

    @Column(name = "CARD_NUMBER", columnDefinition = "number(16)", nullable = false)
    private BigDecimal cardNumber;

    @Column(name = "DESCRIPTION", length = 255, columnDefinition = "nvarchar2(255)")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "STATUS", length = 20, columnDefinition = "nvarchar2(20)")
    private Status status;

    @Column(name = "PAYMENT_SERVICE", nullable = false, columnDefinition = "number(10)")
    private Integer paymentService;

};
