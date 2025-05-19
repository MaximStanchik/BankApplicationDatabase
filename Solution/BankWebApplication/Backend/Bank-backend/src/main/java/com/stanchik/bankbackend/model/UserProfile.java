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
@Table(name = "User_Profile", schema = "admin_user")
public class UserProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "USER_ID", nullable = false)
    @Column(name = "USER_ID", nullable = false, columnDefinition = "number(10)")
    private AppUser userId;

    @Column(name="FIRST_NAME", nullable = false, length = 50, columnDefinition = "nvarchar2(50)")
    private String firstName;

    @Column(name="LAST_NAME", nullable = false, length = 50, columnDefinition = "nvarchar2(50)")
    private String lastName;

    @Column(name = "MIDDLE_NAME", length = 50, columnDefinition = "nvarchar2(50)")
    private String middleName;

    @Column(name = "ADDRESS", length = 255, columnDefinition = "nvarchar2(255)")
    private String address;

    @Column(name = "BIRTH_DATE", columnDefinition = "date")
    private Date birthDate;

    @Column(name = "EMAIL", length = 100, columnDefinition = "nvarchar2(100)")
    private String email;

    @Column(name = "PASSPORT_NUM", nullable = false, length = 50, columnDefinition = "nvarchar2(50)")
    private String passportNum;

    @Column(name = "PHONE_NUMBER", length = 50, columnDefinition = "nvarchar2(50)")
    private String phoneNumber;
}
