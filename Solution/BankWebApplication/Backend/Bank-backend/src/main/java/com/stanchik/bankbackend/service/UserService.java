package com.stanchik.bankbackend.service;

import com.stanchik.bankbackend.model.dto.user.registration.RegisterUserRequestDto;
import com.stanchik.bankbackend.model.dto.user.registration.RegisterUserResponseDto;
import lombok.RequiredArgsConstructor;
import oracle.jdbc.OracleConnection;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.ResultSet;

import static java.sql.Types.REF_CURSOR;

@Service
@RequiredArgsConstructor
public class UserService {

    private final JdbcTemplate jdbcTemplate;

    public RegisterUserResponseDto registerUser(RegisterUserRequestDto dto) {
        try (OracleConnection connection = (OracleConnection) jdbcTemplate.getDataSource().getConnection()) {
            CallableStatement stat = connection.prepareCall("{call system.register_user(?, ?, ?)}");
            stat.setString(1, dto.login());
            stat.setString(2, dto.password());
            stat.registerOutParameter(3, REF_CURSOR);
            stat.executeUpdate();
            ResultSet rs = (ResultSet) stat.getObject(4);
            rs.next();
            return new RegisterUserResponseDto(rs.getLong(1), dto.login());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
       /*
            String sql = "{ ? = call REGISTER_USER(?, ?) }";
            return jdbcTemplate.execute((Connection conn) -> {
                try (CallableStatement stmt = conn.prepareCall(sql)) {
                    stmt.registerOutParameter(1, Types.NUMERВ индексе отсутствует параметр IN или OUT);
                    stmt.setString(2, dto.login());
                    stmt.setString(3, dto.password());
                    stmt.execute();
                    return new RegisterUserResponseDto((long) stmt.getInt(1), dto.login());
                }
            });
        } catch (DataAccessException e) {
            throw new RuntimeException("Error calling REGISTER_USER function", e);
        }
        */

//    public RegisterUserResponseDto registerUser(RegisterUserRequestDto registerUserRequestDto) {
//        SimpleJdbcCall simpleJdbcCall = new SimpleJdbcCall(jdbcTemplate)
//                .withProcedureName("REGISTER_USER")
//                .withoutProcedureColumnMetaDataAccess()
//                .withSchemaName("system")
//                .declareParameters(
//                        new SqlParameter("p_login", Types.VARCHAR),
//                        new SqlParameter("p_password", Types.VARCHAR),
//                        new SqlOutParameter("p_user_id", Types.NUMERIC),
//                        new SqlOutParameter("p_user_login", Types.VARCHAR)
//                );
//
//        SqlParameterSource in = new MapSqlParameterSource()
//                .addValue("p_login", registerUserRequestDto.login())
//                .addValue("p_password", registerUserRequestDto.password());
//
//        Map out = simpleJdbcCall.execute(in);
//
//        Number userId = (Number) out.get("p_user_id");
//        String userLogin = (String) out.get("p_user_login");
//
//        return new RegisterUserResponseDto(userId.longValue(), userLogin);
//
//    }

    //private static final SecureRandom secureRandom = new SecureRandom(); //threadsafe
    //private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder(); //threadsafe

//    public RegisterUserResponseDto register (RegisterUserRequestDto requestDto) {
//        userRepository.findByLogin(requestDto.login())
//                .map(user -> {throw new RuntimeException("user already exists");});
//
//        if (!validateUserInput(requestDto.login(), requestDto.password())) {
//            throw new RuntimeException("Login or password are not valid");
//        }
//        else {
//            User user = userRepository.save(new User(null, requestDto.login(), requestDto.password(), new ArrayList<>()));
//            return new RegisterUserResponseDto(user.getId(), user.getLogin());
//        }
//    }
/*
    public boolean validateUserInput (String login, String password) {
        if (!login.matches("[a-zA-Z0-9]{2,255}") || !password.matches("[a-zA-Z0-9%!\\-:;]{2,255}")) {
            return false;
        }
        else {
            return true;
        }
    }

    public static String generateNewToken() {
        byte[] randomBytes = new byte[24];
        secureRandom.nextBytes(randomBytes);
        return base64Encoder.encodeToString(randomBytes);
    }
*/
//    public LoginResponseDto login (LoginRequestDto requestDto) {
//
//        return userRepository.findByLogin(requestDto.login()).map(user -> {
//            if (user.getPassword().equals(requestDto.password())) {
//                return new LoginResponseDto(user.getId(), generateNewToken());
//            }
//            else {
//                throw new RuntimeException("User password doesn't match");
//            }
//        }).orElseThrow();
//
//    }

//    public void updateUser(UpdateLoginAndPasswordRequestDto requestDto) {
//        userRepository.findById(requestDto.userId()).map(user -> {
//            if (user.getPassword().equals(requestDto.oldPassword())) {
//                user.setLogin(requestDto.newLogin());
//                user.setPassword(requestDto.newPassword());
//                return userRepository.save(user);
//            }
//            else {
//                throw new RuntimeException("User password doesn't match");
//            }
//        }).orElseThrow(() -> new RuntimeException("User not found"));
//    }
//
//    public List<User> getAll() {
//        return Streamable.of(userRepository.findAll()).toList();
//    }

    //TODO: дописать еще методы те что в дто у меня описаны. Дописать схему бд. Дописать все остальные сервисы. Потом надо будет проверить что все вообще работает. Потом дописать контроллеры. Потом написать фронтенд.
    //TODO: дописать контроллеры и сервисы, создание объектов в бд + попробовать найти в оракле созданные таблицы

}