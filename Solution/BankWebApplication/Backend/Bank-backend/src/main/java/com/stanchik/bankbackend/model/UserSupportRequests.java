package com.stanchik.bankbackend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "User_Support_Requests", schema = "admin_user")
public class UserSupportRequests {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID", columnDefinition = "number(10)")
    private Integer id;

    @Lob
    @Column(name = "CONTENT", columnDefinition = "clob")
    private String content;

    @Column(name = "DATE_TIME", columnDefinition = "timestamp")
    private Timestamp dateTime;

    @Column(name = "USER_ID", nullable = false, columnDefinition = "number(10)")
    private Integer userId;

};
