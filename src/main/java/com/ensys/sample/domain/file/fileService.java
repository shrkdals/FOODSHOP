package com.ensys.sample.domain.file;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.imageio.ImageIO;
import javax.inject.Inject;
import javax.swing.ImageIcon;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.ensys.sample.domain.BaseService;
import com.ensys.sample.domain.common.commonService;
import com.ensys.sample.domain.user.SessionUser;
import com.ensys.sample.utils.FTPUploader;
import com.ensys.sample.utils.SessionUtils;

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

	public void fileClear(HashMap<String, Object> param) {
		String strPath = (String) param.get("path");
		File path = new File(strPath);
		File[] fileList = path.listFiles();

		for (File file : fileList) {
			if (file.isFile()) {
				System.out.println("fileName : " + file.getName() + " , strPath : " + strPath);
				goThumnail2(file, new File(strPath + "/" + file.getName()));
			}
		}
	}

	private File multipartToFile(MultipartFile mfile) {
		File file = null;
		try {
			file = new File(mfile.getOriginalFilename());
			file.createNewFile();
			FileOutputStream fos = new FileOutputStream(file);
			fos.write(mfile.getBytes());
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return file;
	}

	private void goThumnail2(File f, File path) {
		int destWidth = 0;
		int destHeight = 0;
		try {
			BufferedImage original = ImageIO.read(f);

			if (original == null)
				return;
			// 450px로 width 만들기 위한 나누는 수
			int divideValue = 1;

			// 이미지 width를 450으로 맞추기
			// 이미지 크기가 사이즈와 관계 있기 때문에 width가 450px 이상일 경우에만 450으로 width를 맞추어 준다.

			// 450px 보다 작은 경우에는 나누는 수를 1로 하여 원본 그대로의 이미지를 저장한다.
			if (original.getWidth(null) > 450) {
				divideValue = original.getWidth(null) / 450;
			}

			destWidth = original.getWidth(null) / divideValue;
			destHeight = original.getHeight(null) / divideValue;

			// 이미지 사이즈 수정(width를 450px로 변경)
			Image resize = original.getScaledInstance(original.getWidth(null) / divideValue,
					original.getHeight(null) / divideValue, Image.SCALE_SMOOTH);

			int pixels[] = new int[destWidth * destHeight];
			PixelGrabber pg = new PixelGrabber(resize, 0, 0, destWidth, destHeight, pixels, 0, destWidth);
			try {
				pg.grabPixels();
			} catch (InterruptedException e) {
				throw new IOException(e.getMessage());
			}
			BufferedImage destImg = new BufferedImage(destWidth, destHeight, BufferedImage.TYPE_INT_RGB);
			destImg.setRGB(0, 0, destWidth, destHeight, pixels, 0, destWidth);

			ImageIO.write(destImg, "jpg", path);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void goThumnail(MultipartFile orgnMf, File path) {

		int destWidth = 0;
		int destHeight = 0;
		try {
			File f = multipartToFile(orgnMf);
			Image original = null;
			try {
				String suffix = f.getName().substring(f.getName().lastIndexOf('.') + 1).toLowerCase();
				if (suffix.equals("bmp") || suffix.equals("png") || suffix.equals("gif")) {
					original = ImageIO.read(f);
				} else {
					// JPEG 포맷
					original = new ImageIcon(f.toURL()).getImage();
				}

				// 450px로 width 만들기 위한 나누는 수
				int divideValue = 1;

				// 이미지 width를 450으로 맞추기

				// 이미지 크기가 사이즈와 관계 있기 때문에 width가 450px 이상일 경우에만 450으로 width를 맞추어 준다.

				// 450px 보다 작은 경우에는 나누는 수를 1로 하여 원본 그대로의 이미지를 저장한다.
				if (original.getWidth(null) > 450) {
					divideValue = original.getWidth(null) / 450;
				}

				destWidth = original.getWidth(null) / divideValue;
				destHeight = original.getHeight(null) / divideValue;

				// 이미지 사이즈 수정(width를 450px로 변경)
				Image resize = original.getScaledInstance(original.getWidth(null) / divideValue,
						original.getHeight(null) / divideValue, Image.SCALE_SMOOTH);

				int pixels[] = new int[destWidth * destHeight];
				PixelGrabber pg = new PixelGrabber(resize, 0, 0, destWidth, destHeight, pixels, 0, destWidth);
				try {
					pg.grabPixels();
				} catch (InterruptedException e) {
					throw new IOException(e.getMessage());
				}
				BufferedImage destImg = new BufferedImage(destWidth, destHeight, BufferedImage.TYPE_INT_ARGB);
				destImg.setRGB(0, 0, destWidth, destHeight, pixels, 0, destWidth);

				ImageIO.write(destImg, "png", path);

			} catch (Exception e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
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
						
						try {
							goThumnail(cropMf.get(i), file); // 썸네일
						} catch(Exception e) {
							cropMf.get(i).transferTo(file);
						}
						
						ftpUploader.uploadFile("/rahan2000/" + fileName.get("FILE_PATH") + "/" + savedFileNm, savedFileNm, "/upload/" + fileName.get("FILE_PATH"));

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

	public void showImage(MultipartFile orgnMf, File path) throws Exception {

		File file = multipartToFile(orgnMf);

		int thumbnail_width = 125;
		int thumbnail_height = 125;

		BufferedImage buffer_original_image = ImageIO.read(file);
		BufferedImage buffer_thumbnail_image = new BufferedImage(thumbnail_width, thumbnail_height, BufferedImage.TYPE_3BYTE_BGR);
		Graphics2D graphic = buffer_thumbnail_image.createGraphics();
		graphic.drawImage(buffer_original_image, 0, 0, thumbnail_width, thumbnail_height, null);

		ImageIO.write(buffer_thumbnail_image, "png", path);

	}

	@Transactional
	public void insertFsFileBrowse(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();

		param.put("CD_COMPANY", user.getCdCompany());
		param.put("ID_INSERT", user.getIdUser());

		fileMapper.insertFsFileBrowse(param);
	}

	@Transactional
	public void deleteFsFileBrowse(HashMap<String, Object> param) {
		SessionUser user = SessionUtils.getCurrentUser();

		param.put("CD_COMPANY", user.getCdCompany());
		param.put("ID_INSERT", user.getIdUser());

		fileMapper.deleteFsFileBrowse(param);
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
	public void fileUpload(List<MultipartFile> mf, List<HashMap<String, Object>> fileName) {

		String filepath = (String) fileName.get(0).get("FILE_PATH");
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
		File files = new File("/rahan2000/" + filepath);
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
			if (mf != null && mf.size() > 0) {
				for (int i = 0; i < mf.size(); i++) {
					originFileNm = mf.get(i).getOriginalFilename();
					savedFileNm = (String) fileName.get(i).get("FILE_NM");
					fileExtension = exe(originFileNm).toLowerCase();

					/* 업로드 할 파일을 만들고 파일을 복사 */
					try {
						file = new File("/rahan2000/" + fileName.get(i).get("FILE_PATH") + "/" + savedFileNm);
						mf.get(i).transferTo(file);

						ftpUploader.uploadFile("/rahan2000/" + fileName.get(i).get("FILE_PATH") + "/" + savedFileNm,
								savedFileNm, "/upload/" + fileName.get(i).get("FILE_PATH"));
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
