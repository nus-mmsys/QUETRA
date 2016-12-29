import bufferbased as bba
import quetra as quetra

class RateAdaptationFactory:

    def create(self, method, r_lst, buff_cap):

        if method == 'bba':
            return bba.BufferBased(r_lst, buff_cap)
        elif method == 'quetra':
            return quetra.Quetra(r_lst, buff_cap)
        else:
            return None


rafactory = RateAdaptationFactory()
