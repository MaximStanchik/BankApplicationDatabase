package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "Payment_Service", schema = "admin_user")
public class PaymentService {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "NAME", length = 100, nullable = false, columnDefinition = "nvarchar2(100)")
    private String name;

    @Column(name = "TYPE", length = 50, nullable = false, columnDefinition = "nvarchar2(50)")
    private String type;

};
