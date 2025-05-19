package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "User_Account", schema = "admin_user")
public class UserAccount {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "ACCOUNT_NUMBER", length = 16, nullable = false, columnDefinition = "nvarchar2(16)")
    private String accountNumber;

    @ManyToOne
    @JoinColumn(name = "CURRENCY_ID", nullable = false)
    @Column(name = "CURRENCY_ID", nullable = false, columnDefinition = "number(3)")
    private Currency currencyId;

    @Column(name = "AMOUNT", precision = 15, scale = 2)
    private BigDecimal amount = BigDecimal.ZERO;

    @ManyToOne
    @JoinColumn(name = "USER_ID", nullable = false)
    @Column(name = "USER_ID", nullable = false, columnDefinition = "number(10)")
    private AppUser userId;

    @OneToMany(mappedBy = "userAccount")
    private List<Credits> credits;

}

