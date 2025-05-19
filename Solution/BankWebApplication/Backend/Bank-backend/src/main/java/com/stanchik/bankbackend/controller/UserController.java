package com.stanchik.bankbackend.controller;

import com.stanchik.bankbackend.model.dto.user.registration.RegisterUserRequestDto;
import com.stanchik.bankbackend.model.dto.user.registration.RegisterUserResponseDto;
import com.stanchik.bankbackend.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RequestMapping("/users")
@RestController
public class UserController {
    private final UserService userService;
    @PostMapping("/register")
    public ResponseEntity<RegisterUserResponseDto> register (@RequestBody RegisterUserRequestDto registerUserRequestDto) {
        return ResponseEntity.ok(userService.registerUser(registerUserRequestDto));
    };

//    @PostMapping("/login")
//    public ResponseEntity<LoginResponseDto> login (@RequestBody LoginRequestDto loginRequestDto) {
//        return ResponseEntity.ok(userService.login(loginRequestDto));
//    };
//    @PutMapping ("")
//    public ResponseEntity<Void> updateUserInfo (@RequestBody UpdateLoginAndPasswordRequestDto loginRequestDto) {
//        userService.updateUser(loginRequestDto);
//        return ResponseEntity.ok().build();
//    };
//
//    @GetMapping()
//    public ResponseEntity<List<User>> getAllUsers () {
//        return ResponseEntity.ok(userService.getAll());
//    }

    //TODO: сделать accountController (создать аккаунт -- post, изменить аккаунт -- put, удалить аккаунт (deletemapping) -- delete, getAllAccounts, getAccountById)
    //TODO: скопировать userService и переписать на хранимые процедуры (у чата спросить) (jdbc.function.)
    //TODO: есть штука в спринге, она будет инициализировать бд (@PostConstract, реализация интерфейса CommandLineRunner)
    //TODO: все 4 метода не работают, потому что используем JDBC, работает через JPA
};
