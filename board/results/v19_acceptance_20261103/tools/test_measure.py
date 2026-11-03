"""Synthetic analyzer/reference checks. These tests are not V19 board evidence."""
import unittest
import numpy as np
from measure import error_metrics, frame_ids, fit_tone, latency_values, times, capture_errors
from golden import Golden, up

class MeasurementTests(unittest.TestCase):
    def test_error_known_offset(self):
        result=error_metrics(np.zeros((4,4)),np.full((4,4),3))
        self.assertEqual(result['mae'],3);self.assertEqual(result['rmse'],3)
        self.assertEqual(result['bias'],3)

    def test_unsigned_subtraction(self):
        result=error_metrics(np.array([1000],dtype='<u2'),np.array([1],dtype='<u2'))
        self.assertEqual(result['bias'],-999)

    def test_frame_mismatch(self):
        with self.assertRaises(ValueError):
            frame_ids([dict(input_id=1,golden_input_id=1,fpga_input_id=2)])

    def test_frame_duplicate(self):
        row=dict(input_id=1,golden_input_id=1,fpga_input_id=1)
        with self.assertRaises(ValueError):frame_ids([row,row])

    def test_amplitude_and_trend(self):
        t=np.arange(600)/60
        result=fit_tone(t,1.25*np.sin(2*np.pi*5.3*t+.7)+2+.03*t,5.3)
        self.assertAlmostEqual(result['peak_amplitude_px'],1.25,places=10)
        self.assertLess(result['residual_rms_px'],1e-10)

    def test_latency_pairs(self):
        x=latency_values([dict(event_id='1',scene_time_s=1,screen_time_s=1.075)])
        self.assertAlmostEqual(x[0],75)
        with self.assertRaises(ValueError):
            latency_values([dict(event_id='1',scene_time_s=2,screen_time_s=1)])

    def test_clock_reset(self):
        with self.assertRaises(ValueError):times([100,101,1])

    def test_nan(self):
        with self.assertRaises(ValueError):error_metrics([1],[float('nan')])

    def test_mid_publish_metadata_is_not_ecc(self):
        c=[0]*133;c[18]=9686;c[33]=0x80020000
        flags,errors=capture_errors(c)
        self.assertEqual(flags,[0,0,0]);self.assertEqual(errors,[0]*6)

    def test_sticky_csi_error_is_not_lost(self):
        c=[0]*133;c[18]=9686;c[33]=0x80020800
        flags,errors=capture_errors(c)
        self.assertEqual(flags,[0,1,0]);self.assertTrue(any(errors))

    def test_constant_preserved(self):
        for alpha in (0,12,30,50):
            model=Golden([.3,-.3,-.8,.4],alpha)
            for _ in range(3):
                np.testing.assert_array_equal(model.process(np.full((64,64),512)),np.full((64,64),512))

    def test_reset_restores_first_frame(self):
        rng=np.random.default_rng(19)
        a=rng.integers(0,1024,(64,64));b=rng.integers(0,1024,(64,64))
        model=Golden([.3,-.3,-.8,.4],50)
        first=model.process(a);model.process(b)
        np.testing.assert_array_equal(model.process(a,reset=True),first)

    def test_resize_half_pixel(self):
        np.testing.assert_allclose(up(np.array([[0.,4.],[8.,12.]])),
             [[0,1,3,4],[2,3,5,6],[6,7,9,10],[8,9,11,12]])

if __name__=='__main__':unittest.main(verbosity=2)
