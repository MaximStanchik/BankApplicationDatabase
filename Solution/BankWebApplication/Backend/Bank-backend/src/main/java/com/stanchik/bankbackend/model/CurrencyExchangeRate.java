package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "Currency_Exchange_Rate", schema = "admin_user")
public class CurrencyExchangeRate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "CURR_ID", nullable = false, columnDefinition = "number(10)")
    private Integer currId;

    @Column(name = "BUY", precision = 15, scale = 4, nullable = false, columnDefinition = "number(15, 4)")
    private BigDecimal buy;

    @Column(name = "SALE", precision = 15, scale = 4, nullable = false, columnDefinition = "number(15, 4)")
    private BigDecimal sale;

    @Column(name = "POSTING_DATE", nullable = false)
    private Date postingDate;

};
