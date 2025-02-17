<?php
require_once('../../setup/koneksi.php');
date_default_timezone_set('asia/jakarta');
if ($_POST['ket'] == '') {
    $respons = [
        'success' => 0,
        'message' => "Data Input tidak boleh kosong !! "
    ];
    echo json_encode($respons);
} else {
    $tujuan = $_POST['tujuan'];
    $ket = $_POST['ket'];
    $usr = $_POST['id'];
    $qs = mysqli_query($koneksi, "SELECT * FROM tmp WHERE jenis = 1 AND user = '$usr'");
    $query = mysqli_query($koneksi, "SELECT MAX(id_barang_masuk) AS max_code FROM tbl_barang_masuk");
    $data = mysqli_fetch_array($query);
    $a = $data['max_code'];
    $urut = (int)substr($a,2,3);
    $urut++;
    $id = "BM" . sprintf("%03s", $urut);
    $tgl = date('Y-m-d');
    while ($c = mysqli_fetch_array($qs)) {
        mysqli_query($koneksi, "INSERT INTO tbl_barang_masuk(id_barang_masuk, barang, jumlah_masuk) VALUES('$id', '$c[kode_br]', '$c[jumlah]')");
        $qstok = mysqli_query($koneksi, "SELECT * FROM tbl_stok WHERE barang ='$c[kode_br]'");
        $x = mysqli_fetch_array($qstok);
        $stok = $x['stok'] + $c['jumlah'];
        $ups = mysqli_query($koneksi, "UPDATE tbl_stok SET stok ='$stok' WHERE barang = '$c[kode_br]'");
    }
    $sm = mysqli_query($koneksi, "SELECT SUM(jumlah_masuk) AS sm FROM tbl_barang_masuk WHERE id_barang_masuk = '$id'");
    $m = mysqli_fetch_array($sm);
    $transaksi = mysqli_query($koneksi, "INSERT INTO tbl_transaksi (id_transaksi,jenis_transaksi,keterangan,total_item,tgl_transaksi,user, tipe) VALUES('$id', '$tujuan', '$ket', '$m[sm]', '$tgl', '$usr', 'M')");
    mysqli_query($koneksi, "DELETE FROM tmp WHERE jenis = 1 AND user = '$usr'");
    if ($transaksi) {
        $respons = [
            'success' => 1,
            'message' => "Berhasil Input Barang Masuk"
        ];
        echo json_encode($respons);
    } else {
        $respons = [
            'success' => 0,
            'message' => "Gagal!!"
        ];
        echo json_encode($respons);
}
}