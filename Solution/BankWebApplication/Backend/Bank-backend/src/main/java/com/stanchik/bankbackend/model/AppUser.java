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
@Table(name = "App_user", schema = "admin_user")
public class AppUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Column(name = "LOGIN", nullable = false, columnDefinition = "nvarchar2(255)")
    private String login;

    @Column(name = "PASSWORD", nullable = false, columnDefinition = "nvarchar2(255)")
    private String password;

};


