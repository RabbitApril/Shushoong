package kh.mclass.shushoong.hotel.model.domain;

import java.util.List;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class HotelReserveDtoRes {

	private String hotelReserveCode;
	private String residenceNameKo;
	private String residenceNameEng;
	private String residenceGender;
	private String residencePhone;
	private String residenceEmail;
	private List<String> request;
	private String reserveCheckIn;
	private String reserveCheckOut;
	private String userId;
	private String roomCap;
	private String hotelCode;
	private String roomCat;
	private String roomAtt;
}
