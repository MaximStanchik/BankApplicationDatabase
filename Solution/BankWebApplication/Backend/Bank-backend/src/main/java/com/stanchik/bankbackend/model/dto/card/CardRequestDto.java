package com.stanchik.bankbackend.model.dto.card;

public record CardRequestDto(Integer accountId, String type, String cardName,
                             String description, String status
)
{

}
