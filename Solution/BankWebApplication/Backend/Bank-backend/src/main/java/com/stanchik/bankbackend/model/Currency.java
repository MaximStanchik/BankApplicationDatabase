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
@Table(name = "Currency", schema = "admin_user")
public class Currency {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "NAME", length = 100, nullable = false, columnDefinition = "varchar2(100)")
    private String name;

    @Column(name = "CODE", length = 3, nullable = false, columnDefinition = "varchar2(3)")
    private String code;

    @OneToMany(mappedBy = "currency")
    private List<Credits> credits;

}
