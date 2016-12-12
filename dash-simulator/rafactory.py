import bufferbased as bba

class RateAdaptationFactory:

    def create(self, method, r_lst, buff_cap):

        if method == 'bba':
            return bba.BufferBased(r_lst, buff_cap)
        else:
            return None


rafactory = RateAdaptationFactory()
