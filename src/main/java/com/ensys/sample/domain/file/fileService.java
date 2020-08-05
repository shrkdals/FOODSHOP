package com.ensys.sample.domain.file;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.common.commonService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.FTPUploader;
import com.ensys.sample.utils.SessionUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

@Service
public class fileService extends BaseService {

	@Inject
	public fileMapper fileMapper;

	@Inject
	public commonService commonservice;

	public List<HashMap<String, Object>> getFileData(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();
		param.put("CD_COMPANY", user.getCdCompany());
		return fileMapper.getFileData(param);
	}

	// 자르기파일 업로드
	public void cropUpload(List<MultipartFile> orgnMf, List<MultipartFile> cropMf, HashMap<String, Object> fileName) {

		String filepath = (String) fileName.get("FILE_PATH");
		System.out.println("filepath : " + filepath);

		String path = "";
		for (int i = 0; i < filepath.split("/").length; i++) {
			if (i != 0) {
				path += "/";
			}
			path += filepath.split("/")[i];

			File files = new File("/rahan2000/" + path);
			if (!files.isDirectory()) {
				files.mkdir();
			}
		}
		File files = new File("/rahan2000/" + filepath + "/original");
		if (!files.isDirectory()) {
			files.mkdir();
		}

		File file = null;
		SessionUser user = SessionUtils.getCurrentUser();

		String originFileNm = null;
		String savedFileNm = null;
		String fileExtension = null;
		try {
			FTPUploader ftpUploader = new FTPUploader("rahan2002.cafe24.com", "rahan2002", "rahan123!@");
			if (orgnMf != null && orgnMf.size() > 0) {
				for (int i = 0; i < orgnMf.size(); i++) {
					originFileNm = orgnMf.get(i).getOriginalFilename();
					savedFileNm = (String) fileName.get("FILE_NAME");
					fileExtension = exe(originFileNm).toLowerCase();

					/* 업로드 할 파일을 만들고 파일을 복사 */
					try {
						file = new File("/rahan2000/" + fileName.get("FILE_PATH") + "/original/" + savedFileNm);
						orgnMf.get(i).transferTo(file);

						ftpUploader.uploadFile("/rahan2000/" + fileName.get("FILE_PATH") + "/original/" + savedFileNm,
								savedFileNm, "/upload/" + fileName.get("FILE_PATH") + "/original/");
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			if (cropMf != null && cropMf.size() > 0) {
				for (int i = 0; i < cropMf.size(); i++) {
					originFileNm = cropMf.get(i).getOriginalFilename();
					savedFileNm = (String) fileName.get("FILE_NAME");
					fileExtension = exe(originFileNm).toLowerCase();

					/* 업로드 할 파일을 만들고 파일을 복사 */
					try {
						file = new File("/rahan2000/" + fileName.get("FILE_PATH") + "/" + savedFileNm);
						cropMf.get(i).transferTo(file);

						ftpUploader.uploadFile("/rahan2000/" + fileName.get("FILE_PATH") + "/" + savedFileNm,
								savedFileNm, "/upload/" + fileName.get("FILE_PATH"));

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			ftpUploader.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 파일 데이터 추가 호출
	@Transactional
	public void insertFsFile(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();

		param.put("CD_COMPANY", user.getCdCompany());
		param.put("ID_INSERT", user.getIdUser());

		fileMapper.insertFsFile(param);
	}

	// 파일 업로드
	public HashMap<String, Object> fileUpload(List<MultipartFile> mf, List<HashMap<String, Object>> fileName) {

		String path0 = "D:/ERP-U";

		if (path0 != null) {
			File dir = new File(path0);

			/* 폴더가 없을 경우 생성 */
			if (!dir.isDirectory()) {
				dir.mkdir();
			}
		}

		String path1 = "D:/ERP-U/Upload";

		if (path1 != null) {
			File dir = new File(path1);

			/* 폴더가 없을 경우 생성 */
			if (!dir.isDirectory()) {
				dir.mkdir();
			}
		}

		String path = "D:/ERP-U/Upload/QRAY_TEMP";

		if (path != null) {
			File dir = new File(path);

			/* 폴더가 없을 경우 생성 */
			if (!dir.isDirectory()) {
				dir.mkdir();
			}
		}

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chkVal", "N");
		resultMap.put("FILE_PATH", path);
		resultMap.put("MSG", "성공적으로 저장되었습니다.");

		File file = null;

		SessionUser user = SessionUtils.getCurrentUser();

		String originFileNm = null;
		String savedFileNm = null;
		String fileExtension = null;

		if (mf != null && mf.size() > 0) {
			for (int i = 0; i < mf.size(); i++) {
				originFileNm = mf.get(i).getOriginalFilename();
				savedFileNm = (String) fileName.get(i).get("FILE_NAME");
				fileExtension = exe(originFileNm).toLowerCase();

				/* 업로드 할 파일을 만들고 파일을 복사 */
				try {
					file = new File(path + "/" + savedFileNm + "." + fileExtension);
					mf.get(i).transferTo(file);
				} catch (Exception e) {
					resultMap.put("MSG", "파일 업로드 과정 중 에러가 발생하였습니다. \n " + e);
					resultMap.put("chkVal", "Y");
					resultMap.put("FILE_PATH", path);
				}
			}
		}
		return resultMap;
	}

	// MA_FILEINFO IU패키지 테이블 데이터 삭제
	@Transactional
	public void MaFileInfoDelete(HashMap<String, Object> item) {
		fileMapper.MaFileInfoDelete(item);
	}

	// MA_FILEINFO IU패키지 테이블 데이터 추가
	@Transactional
	public void MaFileInfoInsert(HashMap<String, Object> item) {
		fileMapper.MaFileInfoInsert(item);
	}

	// 파일삭제추가 호출
	public void BbsFileModify(String BOARD_TYPE, String SEQ, HashMap<String, Object> fileData) {
		List<HashMap<String, Object>> delete = (List<HashMap<String, Object>>) fileData.get("delete");
		List<HashMap<String, Object>> gridData = (List<HashMap<String, Object>>) fileData.get("gridData");

		deleteFile(BOARD_TYPE, delete);
		insertFile(BOARD_TYPE, SEQ, gridData);
	}

	// 파일 데이터 추가 호출
	public HashMap<String, Object> insertFile(String BOARD_TYPE, String SEQ, List<HashMap<String, Object>> fileData) {
		SessionUser user = SessionUtils.getCurrentUser();
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chkVal", "N");
		resultMap.put("MSG", "성공적으로 저장되었습니다.");

		HashMap<String, Object> parameterMap = new HashMap<String, Object>();
		if (fileData != null && fileData.size() > 0) {
			for (HashMap<String, Object> item : fileData) {

				parameterMap.put("CD_COMPANY", user.getCdCompany());
				parameterMap.put("BOARD_TYPE", BOARD_TYPE);
				parameterMap.put("SEQ", SEQ);
				parameterMap.put("FILE_NAME", item.get("FILE_NAME"));
				parameterMap.put("ORGN_FILE_NAME", item.get("ORGN_FILE_NAME"));
				parameterMap.put("FILE_PATH", item.get("FILE_PATH"));
				parameterMap.put("FILE_EXT", item.get("FILE_EXT"));
				parameterMap.put("FILE_SIZE", item.get("FILE_SIZE"));
				parameterMap.put("FILE_BYTE", item.get("FILE_BYTE"));
				parameterMap.put("ID_INSERT", user.getIdUser());

				this.BbsFileInsert(parameterMap);

			}
		}
		return resultMap;
	}

	// 파일삭제, 데이터삭제 호출
	public HashMap<String, Object> deleteFile(String BOARD_TYPE, List<HashMap<String, Object>> SEQ_FILES) {

		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("chkVal", "N");
		resultMap.put("MSG", "성공적으로 저장되었습니다.");

		SessionUser user = SessionUtils.getCurrentUser();

		if (SEQ_FILES != null && SEQ_FILES.size() > 0) {
			for (HashMap<String, Object> item : SEQ_FILES) {
				HashMap<String, Object> parameterMap = new HashMap<String, Object>();
				HashMap<String, Object> deleteMap = new HashMap<String, Object>();
				parameterMap.put("CD_COMPANY", user.getCdCompany());
				parameterMap.put("BOARD_TYPE", BOARD_TYPE);
				parameterMap.put("SEQ", item.get("SEQ"));
				parameterMap.put("SEQ_FILE", item.get("SEQ_FILE"));

				File delFile = new File(
						item.get("FILE_PATH") + "/" + item.get("FILE_NAME") + "." + item.get("FILE_EXT"));

				if (delFile.exists()) {
					if (delFile.delete()) {
						resultMap.put("chkVal", "N");
						resultMap.put("MSG", "성공적으로 저장되었습니다.");
					} else {
//                resultMap.put("chkVal", "N");
//                resultMap.put("MSG", "파일삭제 실패하였습니다.");
					}
				} else {
//            resultMap.put("chkVal", "N");
//            resultMap.put("MSG", "파일이 존재하지 않습니다.");
				}

				this.BbsFileDelete(parameterMap);
			}
		}

		return resultMap;
	}

	// 파일 데이터 추가
	@Transactional
	public void BbsFileInsert(HashMap<String, Object> request) {
		fileMapper.BbsFileInsert(request);
	}

	// 파일 데이터 삭제
	@Transactional
	public HashMap<String, Object> BbsFileDelete(HashMap<String, Object> request) {
		HashMap<String, Object> result = new HashMap<String, Object>();
		result = fileMapper.BbsFileDelete(request);
		return result;
	}

	// 파일브라우저 조회
	public List<HashMap<String, Object>> BbsFileSearch(HashMap<String, Object> param) {
		return fileMapper.BbsFileSearch(param);
	}

	// 파일브라우저 조회
	public List<HashMap<String, Object>> getFiDocuFile(HashMap<String, Object> param) {
		return fileMapper.getFiDocuFile(param);
	}

	// 파일복사
	public void copyfidocuFile(HashMap<String, Object> file, String CD_COMPANY, String NO_DOCU) {
		// 원본 파일경로
		String oriFilePath = file.get("FILE_PATH") + "/" + file.get("FILE_NAME") + "." + file.get("FILE_EXT");
		File oriFile = new File(oriFilePath);

		File copyFolder0 = new File("D:/ERP-U/shared"); // 복사될 폴더
		/* 폴더가 없을 경우 생성 */
		if (!copyFolder0.isDirectory()) {
			copyFolder0.mkdir();
		}

		File copyFolder1 = new File("D:/ERP-U/shared/Download"); // 복사될 폴더
		/* 폴더가 없을 경우 생성 */
		if (!copyFolder1.isDirectory()) {
			copyFolder1.mkdir();
		}

		File copyFolder2 = new File("D:/ERP-U/shared/Download/FI"); // 복사될 폴더
		/* 폴더가 없을 경우 생성 */
		if (!copyFolder2.isDirectory()) {
			copyFolder2.mkdir();
		}

		File copyFolder3 = new File("D:/ERP-U/shared/Download/FI/" + CD_COMPANY); // 복사될 폴더
		// * 폴더가 없을 경우 생성*//*
		if (!copyFolder3.isDirectory()) {
			copyFolder3.mkdir();
		}

		File copyFolder = new File("D:/ERP-U/shared/Download/FI/" + CD_COMPANY + "/" + NO_DOCU); // 복사될 폴더
		// * 폴더가 없을 경우 생성*//*
		if (!copyFolder.isDirectory()) {
			copyFolder.mkdir();
		}
		/*
		 * File copyFolder1 = new File("D:/ERP-U/Upload/" + MODULE); // 복사될 폴더
		 */
		/* 폴더가 없을 경우 생성 *//*
							 * if (!copyFolder1.isDirectory()) { copyFolder1.mkdir(); }
							 * 
							 * File copyFolder = new File("D:/ERP-U/Upload/" + MODULE + "/" + CD_FILE); //
							 * 복사될 폴더
							 *//* 폴더가 없을 경우 생성 *//*
													 * if (!copyFolder.isDirectory()) { copyFolder.mkdir(); }
													 */

		try {

			FileInputStream fis = new FileInputStream(oriFile); // 읽을파일
			FileOutputStream fos = new FileOutputStream(copyFolder + "/" + file.get("ORGN_FILE_NAME")); // 복사할파일

			int fileByte = 0;
			// fis.read()가 -1 이면 파일을 다 읽은것
			while ((fileByte = fis.read()) != -1) {
				fos.write(fileByte);
			}
			// 자원사용종료
			fis.close();
			fos.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return;
		} catch (IOException e) {
			e.printStackTrace();
			return;
		}
	}

	// 파일복사
	public void copyFile(HashMap<String, Object> file, String MODULE, String CD_FILE) {
		// 원본 파일경로
		String oriFilePath = file.get("FILE_PATH") + "/" + file.get("FILE_NAME") + "." + file.get("FILE_EXT");
		File oriFile = new File(oriFilePath);

		File copyFolder0 = new File("D:/ERP-U/Upload/"); // 복사될 폴더
		/* 폴더가 없을 경우 생성 */
		if (!copyFolder0.isDirectory()) {
			copyFolder0.mkdir();
		}

		File copyFolder = new File("D:/ERP-U/Upload/" + CD_FILE); // 복사될 폴더
		// * 폴더가 없을 경우 생성*//*
		if (!copyFolder.isDirectory()) {
			copyFolder.mkdir();
		}

		/*
		 * File copyFolder1 = new File("D:/ERP-U/Upload/" + MODULE); // 복사될 폴더
		 *//* 폴더가 없을 경우 생성 *//*
								 * if (!copyFolder1.isDirectory()) { copyFolder1.mkdir(); }
								 * 
								 * File copyFolder = new File("D:/ERP-U/Upload/" + MODULE + "/" + CD_FILE); //
								 * 복사될 폴더
								 *//* 폴더가 없을 경우 생성 *//*
														 * if (!copyFolder.isDirectory()) { copyFolder.mkdir(); }
														 */

		try {

			FileInputStream fis = new FileInputStream(oriFile); // 읽을파일
			FileOutputStream fos = new FileOutputStream(copyFolder + "/" + file.get("ORGN_FILE_NAME")); // 복사할파일

			int fileByte = 0;
			// fis.read()가 -1 이면 파일을 다 읽은것
			while ((fileByte = fis.read()) != -1) {
				fos.write(fileByte);
			}
			// 자원사용종료
			fis.close();
			fos.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return;
		} catch (IOException e) {
			e.printStackTrace();
			return;
		}
	}

	private String exe(String fileName) {
		int fileNameExtensionIndex = fileName.lastIndexOf('.') + 1;
		String fileNameExtension = fileName.toLowerCase().substring(fileNameExtensionIndex, fileName.length());
		return fileNameExtension;
	}

	private String getFileSize(long size) {
		String[] gubn = { "Byte", "KB", "MB" };
		String returnSize = "";
		int gubnKey = 0;
		double changeSize = 0;
		long fileSize = 0;
		try {
			fileSize = size;
			for (int x = 0; (fileSize / (double) 1024) > 0; x++, fileSize /= (double) 1024) {
				gubnKey = x;
				changeSize = fileSize;
			}
			returnSize = changeSize + gubn[gubnKey];
		} catch (Exception ex) {
			returnSize = "0.0 Byte";
		}

		return returnSize;
	}

	private boolean isValidExtension(String originalName) {
		String originalNameExtension = originalName.substring(originalName.lastIndexOf(".") + 1);
		switch (originalNameExtension) {
		case "jpg":
		case "png":
		case "gif":
			return true;
		}
		return false;
	}

}
