package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Credit_Type", schema = "admin_user")
public class CreditType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "TYPE", length = 50, nullable = false, columnDefinition = "nvarchar2(50)")
    private String type;

    @Column(name = "CREDIT_NAME", length = 100, nullable = false, columnDefinition = "nvarchar2(100)")
    private String creditName;

    @Column(name = "DESCRIPTION", length = 255, nullable = false, columnDefinition = "nvarchar2(255)")
    private String description;

    @OneToMany(mappedBy = "creditType")
    private List<Credits> credits;

};
